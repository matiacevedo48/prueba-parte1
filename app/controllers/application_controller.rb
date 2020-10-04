class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :configure_permited_parameters, if: :devise_controller?

    def authenticate_admin!
        redirect_to new_user_session_path unless (!current_user.nil? && current_user.admin)
    end
    

    def user_full_name(user)
        arr_friends = Friend.where(user_id: user).pluck(:friend_id)
        arr_friends.push(user)
        friend_not_follow = User.where.not(id: arr_friends)
        count = 0
        result = []
        friend_not_follow.shuffle.each do |user|
            count += 1
            break if count > 5
            result.push(user)
        end

        return result.shuffle
    end

    protected
    def configure_permited_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :photo_url, :header_photo])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :photo_url, :header_photo])
    end

    private
    def hashtag_arr
        tweets = Tweet.all
        new_array = []
        tweets.each do |tweet|
        count_word = 0
        key_number = 0
        hashtag = ""
        validate = false
        tweet.content.split(" ").each do |word|
            count_word += 1
            if word.start_with?("<")
                key_number = count_word
                hashtag = word
                validate = true
            elsif key_number+1 == count_word && validate
                new_word = word.sub('/', '/all_tweets/')
                hashtag += "#{new_word}"
                new_array.push(hashtag)
            end
        end
        end
        return new_array
    end

end