class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  load_and_authorize_resource

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).includes(:tags).page(params[:page]).per_page(2)
    
    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
 end

  def show
    @article = Article.find(params[:id])
    if request.path != article_path(@article)
      redirect_to @article, status: :moved_permanently
    end
  end

  def new
    @article = current_user.articles.build
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    params[:article][:tag_list] = params[:article][:tag_list].tr(","," ")
    @article = current_user.articles.build(article_params)
    if @article.save
      ArticleMailer.article_created(current_user,@article).deliver
      flash[:success] = 'Article has been created successfully !!'
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    params[:article][:tag_list] = params[:article][:tag_list].tr(","," ")
    if @article.update(article_params)
      flash[:success] = 'Article has been updated successfully !!'
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:success] = 'Article has been deleted successfully !!'
    redirect_to articles_path
  end

  def vote_article
    vote = params[:vote]
    @article = Article.find(params[:id])
    if vote == "upvote"
      # User disliked article, but clicked upvote, so undislike and like the article
      if current_user.voted_down_on? @article
        @article.undisliked_by current_user
        @article.liked_by current_user
      # User liked article, but clicked upvote, so unlike the article
      elsif current_user.voted_up_on? @article
        @article.unliked_by current_user
      # User likes article for first time
      else
        @article.liked_by current_user
      end 
    elsif vote == "downvote"
      # User liked article, but clicked downvote, so unlike and dislike the article
      if current_user.voted_up_on? @article
        @article.unliked_by current_user
        @article.disliked_by current_user
      # User disliked article, but clicked downvote, so undislike the article
      elsif current_user.voted_down_on? @article
        @article.undisliked_by current_user
      # User dislikes article for first time
      else
        @article.disliked_by current_user
      end
    end
    render json: { pcount: @article.get_likes.size,ncount:@article.get_dislikes.size, id: @article.id }
  end

  private
  def article_params
    params.require(:article).permit(:title, :text, :tag_list, :featured)
  end

end
