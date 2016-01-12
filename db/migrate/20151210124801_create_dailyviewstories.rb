class CreateDailyviewstories < ActiveRecord::Migration
  def change
    create_table :dailyviewstories do |t|
      t.integer :view_id
      t.text :story_id
      t.datetime :date
      t.text :daily_view_id
      t.integer :page_views

      t.timestamps null: false
    end
  end
end
