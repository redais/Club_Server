# By using the symbol ':club', we get Factory Girl to simulate the Club model.
Factory.define :club do |club|
  club.name                  "FC Barcelona"
  club.login                  "fcb_club"
  club.address                "Test Strasse 10"
  club.postale_code           "12122"
  club.city                   "Mainz"
  club.password              "111111"
  club.password_confirmation "111111"
end