class Tweet < ApplicationRecord
  include ActionView::Helpers::UrlHelper
  before_destroy :delete_tweet
  before_save :add_hashtags

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :linking_users, :through => :likes, :source => :user

  validates :content, presence: true, length: { maximum: 140, too_long: "%{count} maximo de caracteres permitidos" }
  
  #Para API
  scope :dates, -> (start, finish) { where('created_at >= ? AND created_at <=?', start, finish) }
  
  paginates_per 50

  scope :tweets_for_me, -> (user) { where(user_id: user.friends.pluck(:friend_id).push(user.id)) }

  def delete_tweet
    Tweet.where(rt_ref: self.id)
    Tweet.where(user_id: self.user_id).update_all(rt_ref: nil)
  end

  def add_hashtags
    new_array = []
    self.content.split(" ").each do |word|
      if word.start_with?("#")
        word_parsed = word.sub '#','%23'
        word = link_to(word, Rails.application.routes.url_helpers.root_path + "?search="+word_parsed )
      end
      new_array.push(word)
    end

    self.content = new_array.join(" ")
  end

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
