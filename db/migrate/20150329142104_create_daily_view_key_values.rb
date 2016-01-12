class CreateDailyViewKeyValues < ActiveRecord::Migration
  def change
    create_table :daily_view_key_values do |t|
      t.integer :view_id, null: false
      t.datetime :date
      t.string :category
      t.string :key
      t.integer :value

      t.timestamps null: false
    end

    add_index :daily_view_key_values, [:date, :view_id]
    add_index :daily_view_key_values, [:date, :view_id, :category]
    add_index :daily_view_key_values, [:date, :view_id, :category, :key], name: 'by_category_key'
    add_index :daily_view_key_values, [:view_id, :category, :key], name: 'by_total_category_key'
  end
end
