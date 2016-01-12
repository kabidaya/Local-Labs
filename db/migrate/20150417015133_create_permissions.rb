class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id, null: false
      t.integer :view_id, null: false

      t.timestamps null: false
    end

    add_index :permissions, :user_id
    add_index :permissions, :view_id
  end
end
