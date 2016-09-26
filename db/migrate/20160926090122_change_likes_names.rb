class ChangeLikesNames < ActiveRecord::Migration
  def self.up
    rename_column :likes, :liker_id, :user_id
  end

  def self.down
    rename_column :likes, :user_id, :liker_id
  end
end
