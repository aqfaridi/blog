class AddWordsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :words, :text
  end
end
