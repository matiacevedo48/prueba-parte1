class AddColumnToTweet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :rt_ref, :integer
  end
end
