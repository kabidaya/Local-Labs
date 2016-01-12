class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.integer :analytics_id, null: false, unique: true

      t.timestamps null: false
    end
    add_index :accounts, :analytics_id, :id
  end
end
