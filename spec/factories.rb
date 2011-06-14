# By using the symbol ':club', we get Factory Girl to simulate the Club model.
Factory.define :club do |club|
  club.name                  "FC Barcelona"
  club.login                  "fcb_club"
  club.address                "Test Strasse 10"
  club.postale_code           "12122"
  club.city                   "Mainz"
  club.password              "111111"
  club.password_confirmation "111111"
  club.contact_person         "test"
end

Factory.define :member do |member|
  member.last_name           "Hartl"
  member.first_name          "Michael"
  member.email               "mhartl@example.com"
  member.sex                  "male"
  member.address                "Test Strasse 10"
  member.postale_code           "12122"
  member.city                   "Mainz"
  member.chip_id              "12121"
  member.password            "foobar"
  member.password_confirmation "foobar"
end
