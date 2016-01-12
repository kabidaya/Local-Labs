class CreateApiDetails < ActiveRecord::Migration
  def change
    create_table :api_details do |t|
      t.text :api_id
      t.text :name
      t.text :url

      t.timestamps null: false
    end
  end
end


