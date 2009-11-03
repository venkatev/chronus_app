class SessionsObserver < ActiveRecord::Observer
  def after_create(sessions)
    SessionsMailer.deliver_signup_notification(sessions)
  end

  def after_save(sessions)
  
    SessionsMailer.deliver_activation(sessions) if sessions.recently_activated?
  
  end
end
