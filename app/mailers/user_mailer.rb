class UserMailer < ActionMailer::Base
  default :from => "admin@richardsdemp.com"
  
  def registration_confirmation(user)
    recipients  user.email
    from        "admin@richardsdemo.com"
    subject     "Thank you for trying out Richard's Demo"
    body        "Hi #{user.name}!"
  end
end
