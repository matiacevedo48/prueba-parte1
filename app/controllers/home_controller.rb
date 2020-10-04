class HomeController < ApplicationController
    def index
        if signed_in?
          if( params[:search] && !params[:search].empty? )
            @tweets = Tweet.tweets_for_me(current_user).where("content LIKE ?", "%#{params[:search]}%").order(created_at: :desc).page params[:page]
          else
            @tweets = Tweet.tweets_for_me(current_user).order(created_at: :desc).page params[:page]
          end
          @tweet = Tweet.new
        else
          @tweets = Tweet.order(created_at: 'desc').page params[:page]
          redirect_to all_tweets_path
        end
      end
    
      def all_tweets
        if( params[:search] && !params[:search].empty? )
          @tweets = Tweet.where("content LIKE ?", "%#{params[:search]}%").order(created_at: :desc).page params[:page]
        else
          @tweets = Tweet.order(created_at: 'desc').page params[:page]
        end
    
      end
    
      def profile
        if current_user.present?
          @following = current_user.users_followed
          @follower = current_user.my_follower
          @likes = current_user.my_likes.order(created_at: :desc).page params[:page]
          @retweets = current_user.retweets_give_it_now.order(created_at: :desc).page params[:page]
          @tweets = current_user.my_tweets.order(created_at: :desc).page params[:page]
          @followed = current_user.users_followed.count
          @follow = Friend.where(friend_id: current_user).count
        else
          redirect_to new_user_session_path
        end
      end
    
    
    
    end