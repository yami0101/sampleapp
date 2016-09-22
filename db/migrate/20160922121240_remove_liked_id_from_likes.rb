class RemoveLikedIdFromLikes < ActiveRecord::Migration
  def change
    remove_column(:likes, :liked_id)
    remove_index :likes, [:liked_id, :liker_id]
    add_index :likes, [:micropost_id, :liker_id], unique: true
  end
end
