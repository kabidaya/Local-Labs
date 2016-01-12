class AddWidgetIdToView < ActiveRecord::Migration
  def change
    add_column :views, :widget_id, :string
  end
end
