class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = params[:user] # Instance variable => available in view
    @user = User.first
    mail(to: @user.email, subject: 'Welcome to Bright Futures')
    # This will render a view in `app/views/user_mailer`!
  end
end
