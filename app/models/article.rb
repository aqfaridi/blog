# == Schema Information
#
# Table name: articles
#
#  id                    :integer          not null, primary key
#  title                 :string
#  text                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  user_id               :integer
#  featured_file_name    :string
#  featured_content_type :string
#  featured_file_size    :integer
#  featured_updated_at   :datetime
#
# Indexes
#
#  index_articles_on_slug  (slug)
#

class Article < ActiveRecord::Base
  has_attached_file :featured, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "featuredimage.jpg"
  validates_attachment_content_type :featured, content_type: /\Aimage\/.*\Z/
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :text, presence: true,
                    length: { minimum: 10}

  def should_generate_new_friendly_id?
    title_changed?
  end                  
end
