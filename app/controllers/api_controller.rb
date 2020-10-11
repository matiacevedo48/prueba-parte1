class ApiController < ApplicationController
    #before_action :set_api, only: [:show, :update, :destroy]
    include ActionController::HttpAuthentication::Basic::ControllerMethods
  
    http_basic_authenticate_with name: "user", password: "password", :only => [ :create]
    require 'json'
    require 'date'
  
    def index
      @tweets = Tweet.all
      @friends = Friend.all
      @retweet = Tweet.where.not(:rt_ref => nil)
      @api_news = []
      @tweets.each do |tweet|
        @tweet_likes = Like.where(:tweet_id  => tweet.id)
        @tweet_retweets = Tweet.where(:rt_ref => tweet.id)
        @retweet_from = Friend.where(:user_id => @retweet)
        @hash = {"id" => tweet.id}
        @hash.merge!("content"=> tweet.content)
        @hash.merge!("user_id"=> tweet.user_id)
        @hash.merge!("like_count"=> @tweet_likes.count)
        @hash.merge!("retweets_count"=> @tweet_retweets.count)
        @hash.merge!("retwitted_from"=> @retweet_from.count)
        @api_news << (@hash)   
      end
      @last_tweets = @api_news.last(50)
      render :json => @last_tweets
    end
  
    def create
      @tweet = Tweet.create(tweet_params)
      @tweet.save
      render json: @tweet
    end
  
    private
    def tweet_params    
      params.require(:tweet).permit(:content, :user_id)
    end
  
  end
  