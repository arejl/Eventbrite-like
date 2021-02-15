require 'faker'

10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: "#{Faker::Job.title} in the #{Faker::Job.field} sector",
    email: Faker::Internet.email
  )
end
