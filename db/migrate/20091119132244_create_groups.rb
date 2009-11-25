class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.decimal :fb_uid, :precision => 30, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
