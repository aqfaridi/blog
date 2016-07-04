class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def new
    @comment = current_user.comments.build 
  end 

  def create
    @article = Article.find(params[:article_id])
    params[:comment][:article_id] = @article.id
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Comment has been created successfully !!'
    end
    redirect_to article_path(@article)
  end
  
  def destroy
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = 'Comment has been deleted successfully !!'
    redirect_to article_path(@article)
  end
  
  private
    def comment_params
      params.require(:comment).permit(:article_id,:body)
  end

end
