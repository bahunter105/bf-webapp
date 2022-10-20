class PreviewDripper < ApplicationDripper
  # each sequence is a campaign. This will dynamically create one by the given slug
  self.campaign = :onboarding

  # gets called before every time we process a drip
  # before_drip do |_drip, mailing|
  #   if mailing.subscription.subscriber.onboarding_completed?
  #     mailing.subscription.unsubscribe!("Completed onboarding")
  #     throw(:abort)
  #   end
  # end

  # map drips to the mailer
  drip :welcome, mailer: 'PreviewMailer', delay: 0.hours
  drip :first_followup, mailer: 'PreviewMailer', delay: 1.hours
  drip :second_followup, mailer: 'PreviewMailer', delay: 2.hours
end
