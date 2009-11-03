require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  #-----------------------------------------------------------------------------
  # ATTRIBUTES AND RELATIONSHIPS
  #-----------------------------------------------------------------------------

  attr_accessible :email, :name, :password, :password_confirmation

  #-----------------------------------------------------------------------------
  # VALIDATIONS
  #-----------------------------------------------------------------------------

  validates_format_of :name, :with => Authentication.name_regex, :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email
  validates_length_of :email, :within => 6..100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = User.find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
end
