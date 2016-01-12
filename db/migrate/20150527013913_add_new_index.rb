class AddNewIndex < ActiveRecord::Migration
  def change
    add_index :daily_view_page_views, :no_root
    add_index :daily_view_key_values, :known
  end
end
