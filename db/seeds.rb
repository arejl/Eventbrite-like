require 'faker'

User.destroy_all
Event.destroy_all

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

5.times do
  Event.create!(
    admin_id: User.all.sample.id,
    title: Faker::Lorem.characters(number: 10),
    description: Faker::Lorem.characters(number: 30),
    start_date: Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 100),
    duration: 45,
    location: Faker::Address.city,
    price: 10
  )
end

5.times do
  Attendance.create!(
    attendee_id: User.all.sample.id,
    event_id: Event.all.sample.id
  )
end