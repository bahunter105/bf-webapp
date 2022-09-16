# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning database..."
User.destroy_all
Workshop.destroy_all

puts "Creating users..."
user1 = {email: "bob@gmail.cs", password: '123456'}
user2 = {email: "jim@gmail.cs", password: '123456'}

[user1, user2].each do |attributes|
  user = User.create!(attributes)
  puts "Created #{user.email}"
end
puts "Finished!"

puts "Creating workshops..."
ws1 = {fullname: 'DB Test WS ', shortname: 'DB Test', summary: 'An Awesome Test', language: 'English', category: "families", price_cents: 7500}
ws2 = {fullname: 'DB Seed WS ', shortname: 'DB Seeding', summary: 'DB Seeding', language: 'English', category: "educators", price_cents: 6700}
ws3 = {fullname: 'DB Test WS -2 ', shortname: 'DB Test -2', summary: 'An Awesome Second Test', language: 'English', category: "families", price_cents: 7500}
ws4 = {fullname: 'DB Seed WS -2', shortname: 'DB Seeding -2', summary: 'DB Second Seeding', language: 'English', category: "educators", price_cents: 6700}


[ws1, ws2].each do |attributes|
  ws = Workshop.create!(attributes)
  puts "Created #{ws.shortname}"
end
puts "Finished!"
