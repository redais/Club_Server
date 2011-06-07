# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110607141309) do

  create_table "clubs", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "address",                   :limit => 100, :default => ""
    t.integer  "postale_code",              :limit => 5,   :default => 0
    t.string   "city",                      :limit => 100, :default => ""
    t.string   "contact_person",            :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "clubs", ["login"], :name => "index_clubs_on_login", :unique => true

  create_table "clubs_members", :id => false, :force => true do |t|
    t.integer "club_id"
    t.integer "member_id"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "club_id"
    t.string   "sex"
    t.string   "email"
    t.string   "city"
    t.string   "address"
    t.integer  "postale_code"
    t.date     "birthday"
    t.integer  "chip_id"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
