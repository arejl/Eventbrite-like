class User < ApplicationRecord
  has_many :organized_events, foreign_key: 'admin_id', class_name: "Event"
  has_many :attendances, foreign_key: 'attendee_id'
  has_many :attended_events, foreign_key: 'attendee_id', class_name: "Event", through: :attendances
  after_create :welcome_send
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
