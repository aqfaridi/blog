class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @tag =  ActsAsTaggableOn::Tag.find(params[:id])
    @articles = Article.tagged_with(@tag.name).paginate(:page => params[:page], :per_page => 2)
  end
end