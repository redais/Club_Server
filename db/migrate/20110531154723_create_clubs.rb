class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table "clubs" do |t|
      t.string :login,            :limit => 40
      t.string :name,             :limit => 100, :default => '', :null => true
      t.column :address,          :limit => 100, :default => '', :null => true
      t.integer :postale_code              
      t.string :city,             :limit => 100, :default => '', :null => true
      t.string :contact_person,   :limit => 100, :default => '', :null => true
      t.string :crypted_password, :string, :limit => 40
      t.string :salt,             :string, :limit => 40
      t.string :remember_token,   :string, :limit => 40
      t.string :remember_token_expires_at 
      t.datetime :created_at                
      t.datetime :updated_at  


    end
    add_index :clubs, :login, :unique => true
  end

  def self.down
    drop_table "clubs"
  end
end
