class AddReturnUserCountToDailyViewMetrics < ActiveRecord::Migration
  def change
    add_column :daily_view_metrics, :return_user_count, :integer, default: 0, null: false
  end
end
