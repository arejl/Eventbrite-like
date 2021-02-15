require 'faker'

User.destroy_all

10.times do
  chosen_first_name = Faker::Name.first_name
  chosen_last_name = Faker::Name.last_name
  User.create!(
    first_name: chosen_first_name,
    last_name: chosen_last_name,
    description: "#{Faker::Job.title} in the #{Faker::Job.field} sector",
    email: "#{chosen_first_name.downcase}@yopmail.com"
  )
end
