class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :account_id, null: false
      t.string :name, null: false
      t.string :analytics_id, null: false, unique: true
      t.timestamps null: false
    end

    create_table :views do |t|
      t.integer :property_id
      t.string :twitter_handle
      t.integer :analytics_id, null: false, unique: true
      t.string :url, null: false, unique: true

      t.timestamps null: false
    end

    add_index :properties, :account_id
    add_index :properties, :name

    add_index :views, :url
    add_index :views, :property_id
    
  end
end
