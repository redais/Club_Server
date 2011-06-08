class Member < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authentication::ModelInstanceMethods
  
  has_and_belongs_to_many :clubs
  
  set_table_name 'members'
  
  validates :last_name,   :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                          :length     => { :maximum => 50 },
                          :allow_nil  => true,
                          :presence   => true
                 
  validates :first_name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                          :length     => { :maximum => 50 },
                          :allow_nil  => true,
                          :presence   => true
                          
  validates :email,       :format     => {:with => Authentication.email_regex, :message => Authentication.bad_email_message},
                          :length     => {:maximum => 50},
                          :presence   => true
  
  validates :password,    :presence     => true,
                          :confirmation => true,
                          :length       => { :within => 6..40 }
                       
  
  
  
  attr_accessible :first_name, :last_name, :sex, :email, :city ,:address, :postale_code, :birthday, :chip_id, :password, :password_confirmation
  # Authenticates a club_member by their email and unencrypted password.  Returns the member or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
end
