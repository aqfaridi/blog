module ApplicationHelper
  def tag_cloud
    @tags = Article.tag_counts_on(:tags)
    # ActsAsTaggableOn::Tag.all 
    # Article.tag_counts_on(:tags).first
    # ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags').uniq.pluck(:id, :name)
  end
end
