class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.integer :club_id
      t.string :sex
      t.string :email
      t.string :city
      t.string :address
      t.integer :postale_code
      t.date :birthday
      t.integer :chip_id
      t.string :password

      t.timestamps
    end
    add_index :members, :email, :unique => true
    add_index :members, :club_id
  end

  def self.down
    drop_table :members
  end
end
