class User < ApplicationRecord
# Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friends, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tweets, dependent: :destroy

  has_many :liked_tweets, :through => :likes, :source => :tweet

  def users_followed
    arr_ids = self.friends.pluck(:friend_id)
    User.find(arr_ids)
  end

  def is_following?(user)
    users_followed.include? (user)
  end

  def friends_count
    self.friends.count
  end

  def my_tweets
    Tweet.where(user_id: self)
  end

  def friends_count
    self.friends.count
  end

  def tweets_count
    self.tweets.where(rt_ref: nil).count
  end

  def likes_give_it
    self.likes.count
  end

  def retweets_give_it
    self.tweets.where.not(rt_ref: nil).count
  end

  def retweets_give_it_now
    self.tweets.where.not(rt_ref: nil)
  end

  def my_likes
    self.liked_tweets
  end

  def my_follower
    arr_followers = Friend.where(friend_id: self.id)
    arr_ids = []
    arr_followers.each { |f| arr_ids.push(f.user_id) }
    User.find(arr_ids)
  end

end
