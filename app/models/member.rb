class Member < ActiveRecord::Base
  
  has_and_belongs_to_many :clubs
  attr_accessible :first_name, :last_name, :sex, :email, :city ,:address, :postale_code, :birthday, :chip_id
      
end
