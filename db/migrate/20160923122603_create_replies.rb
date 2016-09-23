class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :micropost_id
      t.integer :user_id

      t.timestamps
    end

    add_index :replies, :micropost_id
    add_index :replies, :user_id
    add_index :replies, [:micropost_id, :user_id], unique: true
  end
end
