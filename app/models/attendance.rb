class Attendance < ApplicationRecord
  belongs_to :attendee, class_name: "User"
  belongs_to :attended_event, class_name: "Event"
  after_create :attendee_signup
  def attendee_signup
    AttendanceMailer.new_attendee(self).deliver_now
  end
end
