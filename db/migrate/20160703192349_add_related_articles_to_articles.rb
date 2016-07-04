class AddRelatedArticlesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :related_articles, :string
  end
end
