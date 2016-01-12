class AddQueryingColumns < ActiveRecord::Migration
  def change
    add_column :daily_view_page_views, :no_root, :boolean, default: true, null: false
    add_column :daily_view_key_values, :known, :boolean, default: true, null: false
  end
end
