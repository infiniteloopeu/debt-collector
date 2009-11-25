class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
      t.decimal :fb_uid, :precision => 30
      t.decimal :balance, :precision => 15, :scale => 2, :default => 0
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :group_users
  end
end
