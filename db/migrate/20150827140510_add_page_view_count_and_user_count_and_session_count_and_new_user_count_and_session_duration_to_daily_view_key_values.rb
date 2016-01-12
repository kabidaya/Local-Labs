class AddPageViewCountAndUserCountAndSessionCountAndNewUserCountAndSessionDurationToDailyViewKeyValues < ActiveRecord::Migration
  def change
    add_column :daily_view_key_values, :page_view_count, :integer, default: 0
    add_column :daily_view_key_values, :user_count, :integer, default: 0
    add_column :daily_view_key_values, :session_count, :integer, default: 0
    add_column :daily_view_key_values, :new_user_count, :integer, default: 0
    add_column :daily_view_key_values, :session_duration, :integer, default: 0
  end
end
