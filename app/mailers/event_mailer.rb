class EventMailer < ApplicationMailer
  default from: 'yelafo8526@combcub.com'
 
  def new_event(event)
    @event = event
    @user = @event.admin 
    @url  = 'http://monsite.fr/login' 
    mail(to: @user.email, subject: 'Nouvel événement créé !') 
  end
end
