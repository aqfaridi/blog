class ArticleMailer < ApplicationMailer
  def article_created(user,article)
    @user = user
    @article = article
    mail(to: user.email,
         from: "aqfaridi@gmail.com",
         subject: "New Article Created",
    )
  end
end
