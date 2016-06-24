class AddAttachmentFeaturedToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.attachment :featured
    end
  end

  def self.down
    remove_attachment :articles, :featured
  end
end
