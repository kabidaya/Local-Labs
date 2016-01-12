class CreateDailyViewMetrics < ActiveRecord::Migration
  def change
    create_table :daily_view_metrics do |t|
      t.integer :view_id , null: false
      t.datetime :date, null: false
      t.integer :page_view_count, default: 0
      t.integer :user_count, default: 0
      t.integer :session_count, default: 0
      t.integer :user_count, default: 0
      t.integer :new_user_count, default: 0
      t.integer :session_duration, default: 0

      t.timestamps null: false
    end

    add_index :daily_view_metrics, :date
    add_index :daily_view_metrics, :view_id
    add_index :views, :analytics_id
  end
end
