ActiveAdmin.register User do

  permit_params :admin, :email, :username, :photo_url

  index do
    column :email
    column :username
    column :photo_url
    column :friends_count
    column :tweets_count
    column :likes_give_it
    column :retweets_give_it
    actions
  end



end
