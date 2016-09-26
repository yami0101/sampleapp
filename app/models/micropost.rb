class Micropost < ActiveRecord::Base
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope -> { order('created_at DESC') }

  after_save :create_replies

  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :replies, dependent: :destroy

  def reply!(user)
    replies.create!(user_id: user.id)
  end

  def create_replies()
    content.scan(/@(\w+)/) do |match|
      match.map! do |item|
        item.gsub('_', ' ')
      end
      User.where("name = ?", match).each do |user|
        replies.create(user_id: user.id)
      end
    end
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end

  def self.in_reply_to(user)
    replies_to_id = "SELECT micropost_id FROM replies WHERE user_id = :user_id"
    where("id IN (#{replies_to_id})", user_id: user)
  end


end
