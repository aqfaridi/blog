# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#
# Foreign Keys
#
#  fk_rails_3bf61a60d3  (article_id => articles.id)
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
