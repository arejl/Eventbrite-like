class AttendanceMailer < ApplicationMailer
  default from: 'yelafo8526@combcub.com'
 
  def new_attendee(attendance)
    @attendance = attendance
    @attendee = @attendance.attendee
    @event = @attendance.event
    @user = @event.admin
    @url  = 'http://monsite.fr/login' 
    mail(to: @user.email, subject: 'Nouveau participant à ton événement !') 
  end
end
