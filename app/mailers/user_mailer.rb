class UserMailer < ApplicationMailer
  default from: "king-pug@pugglywuggly.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = User.find_by_email(user.email)
    mail :to => user.email, :subject => "Password Reset"
  end

  # def new_order(user)
  #   mail :to => user.email, :subject => "New Order"
  # end
end
