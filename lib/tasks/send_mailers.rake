desc "This the send_mailers task called by the Heroku scheduler add-on"
task :send_mailers => :environment do
  puts "Sending mailers feed..."
  PreviewDripper.perform!
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
