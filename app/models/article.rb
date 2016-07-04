# == Schema Information
#
# Table name: articles
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  text                  :text(65535)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string(255)
#  user_id               :integer
#  featured_file_name    :string(255)
#  featured_content_type :string(255)
#  featured_file_size    :integer
#  featured_updated_at   :datetime
#  words                 :text(65535)
#  related_articles      :string(255)
#
# Indexes
#
#  index_articles_on_slug  (slug)
#

include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base
  has_attached_file :featured, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "featuredimage.jpg"
  validates_attachment_content_type :featured, content_type: /\Aimage\/.*\Z/
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]
  acts_as_taggable_on :tags
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :text, presence: true,
                    length: { minimum: 10}

  after_save :update_words!

  def update_words!
    require 'htmlentities'
    require 'nokogiri'
    doc = Nokogiri::HTML.parse(text)
    doc.xpath("//pre").remove.xpath("//code").remove
    words = doc.text.gsub(/\r\n/, '').downcase
    words = HTMLEntities.new.decode(sanitize(words, :tags => []))
    words = words.split(/\ |\.|\,|\!|\?|\//).reject(&:blank?).sort.join(',')
    words.gsub(/[^a-z\,]/i, '').split(',').reject(&:blank?).sort.join(',')
    update_columns(:words => words)
  end
  
  def update_related!
    articles = Article.all; related = {}
    ifd = inverse_document_frequency(articles)
    (articles - [self]).each do |article|
      score = 0
      intersection = self.words.split(',').multiset(article.words.split(','))
      intersection.each { |word| score += ifd[word] }
      related[article.id] = score
    end
    related = related.sort_by { |k,v| v }.reverse
    related = related.collect { |k,v| k }.first(3).join(',')
    update_columns(:related_articles => related)
  end
  
  def related
    Article.where(:id => related_articles.split(','))
  end
  
  def process_words(text)
    require 'htmlentities'; require 'nokogiri'
    doc = Nokogiri::HTML.parse(text)
    doc.xpath("//pre").remove.xpath("//code").remove
    words = doc.text.gsub(/\r\n/, '').downcase
    words = HTMLEntities.new.decode(sanitize(words, :tags => []))
    words = words.split(/\ |\.|\,|\!|\?|\//).reject(&:blank?).sort.join(',')
    words.gsub(/[^a-z\,]/i, '').split(',').reject(&:blank?).sort.join(',')
    self.update_columns(:words => words)
  end

  private
  def inverse_document_frequency(articles)
    words = {}
    articles.each do |article|
      article.process_words(article.text) if article.words.blank?
      article.words.split(',').uniq.each do |word|
        words[word] = 0 if words[word].nil?
        words[word] += 1
      end
    end
    words.each do |word, freq|
      words[word] = Math.log(articles.size / freq)
    end
    words
  end

  def should_generate_new_friendly_id?
    title_changed?
  end                  
end
