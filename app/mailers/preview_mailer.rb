class PreviewMailer < ApplicationMailer

  def welcome(mailing)
    @workshop = mailing.subscriber
    @user = mailing.user
    mail(to: @user.email, subject: "Thanks for Signing up for the #{@workshop.shortname} Preview")
  end

  def first_followup(mailing)
    @workshop = mailing.subscriber
    @user = mailing.user
    mail(to: @user.email, subject: "First Followup")
  end

  def second_followup(mailing)
    @workshop = mailing.subscriber
    @user = mailing.user
    mail(to: @user.email, subject: "Second Followup")
  end
end
