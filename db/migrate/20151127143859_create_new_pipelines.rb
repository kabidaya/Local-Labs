class CreateNewPipelines < ActiveRecord::Migration
  def change
    create_table :new_pipelines do |t|
      t.text :api_id
      t.text :name
      t.text :url
      t.text :ip
      t.integer :p_no

      t.timestamps null: false
    end
  end
end


