class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    #@articles = Article.all
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true)
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
    validation(current_user,@article)  
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      ArticleMailer.article_created(current_user,@article).deliver
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    validation(current_user,@article)
    @article.destroy
    redirect_to articles_path
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end

end
