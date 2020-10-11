class DatesController < ApplicationController
  
    def show
        date1 = (params[:date1]).to_date
        date2 = (params[:date2]).to_date
        @tweets = Tweet.dates(date1, date2)
        @filter = []
        @tweets.each do |tweet|
          @hash = {"id" => tweet.id}
          @hash.merge!("user_id"=> tweet.user_id)
          @hash.merge!("content"=> tweet.content)
          @hash.merge!("created_at"=> tweet.created_at)
          @filter << (@hash)
        end
        render :json => @filter
    end

    
    private

    def date_params
        params.require(:api).permit(:date1, :date2)
    end

end