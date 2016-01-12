class DropPropertiesTable < ActiveRecord::Migration
  def up
    remove_column :views, :property_id
    drop_table :properties
  end
end
