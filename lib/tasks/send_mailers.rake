task :send_mailers do
  PreviewDripper.perform!
end
