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
#
# Indexes
#
#  index_articles_on_slug  (slug)
#

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
