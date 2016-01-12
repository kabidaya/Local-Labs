class CreatePipelines < ActiveRecord::Migration
  def change
    create_table :pipelines do |t|
      t.text :api_id
      t.text :name
      t.text :url
      t.text :ip
      t.integer :p_no, :limit => 8   # bigint (8 bytes)

      t.timestamps null: false
    end
  end
end
