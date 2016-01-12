class AddNameToViews < ActiveRecord::Migration
  def change
    add_column :views, :name, :string, null: false
  end
end
