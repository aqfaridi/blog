class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def validation(user,article)
    unless user.email == article.user.email
      flash[:alert] = 'You are not authenticated User !!'
      redirect_to article
    end
  end
end
