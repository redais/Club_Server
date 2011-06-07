class ClubsMembers < ActiveRecord::Migration
  def self.up
     create_table :clubs_members, :id => false do |t|
      t.integer :club_id
      t.integer :member_id
      
    end
  
  end

  def self.down
    drop_table :clubs_members
  end
end
