require 'digest/sha1'

class Club < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authentication::ModelInstanceMethods
  
  self.per_page = 10
  
  has_many :members ,:dependent => :destroy


  set_table_name 'clubs'

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 50 },
                    :allow_nil  => true,
                    :presence   => true
                    
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
 
  validates :address, :presence =>true,
                      :length   => { :maximum => 50 }
  
  validates :postale_code, :presence   => true,
                           :format  => {:with => %r{\d{5}(-\d{4})?},:message => "should be 12345 or 12345-1234 "}
 
  
  validates :city, :presence =>true,
                   :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                   :length     => { :maximum => 50 }
                   
  validates :contact_person,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                              :length     => { :maximum => 50 },
                              :allow_nil  => true,
                              :presence   => true
  #before_save :crypted_password
  
  # how to do attr_accessible from here?
  # prevents a club from submitting a crafted form that bypasses activation
  # anything else you want your club to change should be added here.
  attr_accessible :login, :name, :address, :postale_code, :city, :contact_person, :password, :password_confirmation
  


  # Authenticates a club by their login name and unencrypted password.  Returns the club or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  

  

 
 
    


end
