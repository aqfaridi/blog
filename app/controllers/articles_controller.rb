class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).includes(:tags).page(params[:page]).per_page(2)
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
    if @article.update(article_params)
      flash[:success] = 'Article has been updated successfully !!'
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    validation(current_user,@article)
    @article.destroy
    flash[:success] = 'Article has been deleted successfully !!'
    redirect_to articles_path
  end

  private
  def article_params
    params.require(:article).permit(:title, :text, :tag_list, :featured)
  end

end
