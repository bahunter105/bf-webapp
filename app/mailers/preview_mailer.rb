class PreviewMailer < ApplicationMailer

  def welcome(mailing)
    @user = mailing.subscriber
    mail(to: @user.email, subject: "Thanks for Signing up for the Preview")
  end

  def first_followup(mailing)
    @user = mailing.subscriber
    mail(to: @user.email, subject: "First Followup")
  end

  def second_followup(mailing)
    @user = mailing.subscriber
    mail(to: @user.email, subject: "Second Followup")
  end
end
