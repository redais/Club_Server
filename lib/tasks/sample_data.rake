namespace :db do
  desc "Fill database with sample data"
  task :fill => :environment do
    Rake::Task['db:reset'].invoke
    
    20.times do |n|
      name  = "test club #{n+1} "
      login = "club_#{n+1}"
      password  = "111111"
      Club.create!(:name => name,
                   :login => login,
                   :address=>Faker::Address.street_name + "#{n+1}",
                    :postale_code =>"1111#{n}",
                    :city =>Faker::Address.city,
                    :contact_person =>Faker::Name.name,
                    :password => password,
                    :password_confirmation => password)
       
      
    end



    Club.all.each do |club|
      45.times do |n|
        club.members.create!(  :first_name=>Faker::Name.first_name,  
                               :last_name=>Faker::Name.last_name,
                               :sex=>"male",
                               :email=>Faker::Internet.email,
                               :city=> Faker::Address.city,
                               :address=>Faker::Address.street_name + "#{n+1}",
                               :postale_code=>"1111#{n}",
                               :birthday=>"2001-08-#{n+1}",
                               :chip_id=>Faker::Address.zip_code,
                               :password => "111111",
                               :password_confirmation => "111111")
      end
    end

  end
end

 