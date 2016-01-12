class CreateDailyViewPageViews < ActiveRecord::Migration
  def change
    create_table :daily_view_page_views do |t|
      t.integer :view_id, null: false
      t.string :permalink, null: false
      t.datetime :date, null: false
      t.integer :page_views, null: false, default: 0

      t.timestamps null: false
    end

    add_index :daily_view_page_views, :view_id
    add_index :daily_view_page_views, [:view_id, :permalink]
  end
end


