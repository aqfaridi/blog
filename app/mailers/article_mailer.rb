class ArticleMailer < ActionMailer::Base
	def article_created(user)
    mail(to: user.email,
         from: "aqfaridi@gmail.com",
         subject: "Post Created",
         body: "This is ActionMailer"
    )
  end
end