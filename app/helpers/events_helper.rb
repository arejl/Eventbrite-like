module EventsHelper
  def already_subscribed?(event)
    !current_user.nil? && !Attendance.where(attendee_id: current_user.id, attended_event_id:event.id).empty?
  end
end
