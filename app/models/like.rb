class Like < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user
  validates :liker_id, presence: true
  validates :micropost_id, presence: true
end
