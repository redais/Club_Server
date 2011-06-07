namespace :db do
  desc "Fill database with sample data"
  task :make_clubs => :environment do
    Rake::Task['db:reset'].invoke
    Club.create!(:name => "Example Club",
                 :login => "ex_club",
                 :password => "secret",
                 :password_confirmation => "secret",
                 :address=>"hjshdjhsjd",
                 :postale_code => '12134',
                  :city =>'mainz')
    10.times do |n|
      name  = "test club #{n+1} "
      login = "club_#{n+1}"
      password  = "111111"
      Club.create!(:name => name,
                   :login => login,
                   :address=>'test',
                    :postale_code =>'10002',
                    :city =>'test',
                   :password => password,
                   :password_confirmation => password)
       
      
    end
    Club.all.each do |club|
      50.times do |n|
        club.members.create!(:first_name=>"member#{n+1}_firstname",  
                               :last_name=>"member#{n+1}_lastname",
                               :sex=>"member#{n+1} m",
                               :email=>"member#{n+1}_@example.com",
                               :city=>"member#{n+1}_city",
                               :address=>"member#{n+1}_addr",
                               :postale_code=>"#{n+1}1865",
                               :birthday=>"2001-08-09",
                               :chip_id=>"#{n+1}")
      end
    end
  end
end

 