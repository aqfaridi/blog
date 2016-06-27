class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @tag =  ActsAsTaggableOn::Tag.find_by_name(params[:id])
    if @tag == nil 
    	@tag =  ActsAsTaggableOn::Tag.find(params[:id])
    end
    @articles = Article.tagged_with(@tag.name)
  end
end