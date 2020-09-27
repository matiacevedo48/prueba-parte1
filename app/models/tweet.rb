class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :linking_users, :through => :likes, :source => :user
  validates :content, presence: true, length: { maximum: 140, too_long: "%{count} maximo de caracteres permitidos" }

  paginates_per 50

  def is_liked?(user)
    if self.linking_users.include?(user)
      true
    else
      false
    end
  end

  def is_rt?(user, rt)
    if Tweet.where(user_id: user, rt_ref: rt).count == 0
      true
    else
      false
    end
  end

  def remove_like(user)
    Like.where(user: user, tweet:self).first.destroy
  end

  def add_like(user)
    Like.create(user: user, tweet:self)
  end

  def count_rt
    Tweet.where(rt_ref: self.id).count
  end

  def is_retweet?
    rt_ref ? true : false
  end

  def tweet_ref
    Tweet.find(self.rt_ref)
  end

  def list_of_rt
    list = Tweet.where(rt_ref: self)
    return list
  end
end
