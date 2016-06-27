# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  commenter  :string(255)
#  body       :text(65535)
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#
# Foreign Keys
#
#  fk_rails_3bf61a60d3  (article_id => articles.id)
#

class Comment < ActiveRecord::Base
  belongs_to :article
  validates :commenter, presence: true,
	            length: { minimum: 5 }
  validates :body, presence: true,
	            length: { minimum: 5 }
end
