class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end
  
  def destroy
    @article = Article.find(params[:article_id])
    #validation(current_user,@article)
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    flash[:success] = 'Comment has been deleted successfully !!'
    redirect_to article_path(@article)
  end
  
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
  end

end
