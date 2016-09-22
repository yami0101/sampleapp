class AddMicropostIdToLike < ActiveRecord::Migration
  def change
    add_column(:likes, :micropost_id, :integer)
    add_index(:likes, :micropost_id)
  end
end
