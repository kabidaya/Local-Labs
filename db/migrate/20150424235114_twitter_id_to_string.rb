class TwitterIdToString < ActiveRecord::Migration
  def change
    change_column :mentions, :twitter_id, :string, null: false
  end
end
