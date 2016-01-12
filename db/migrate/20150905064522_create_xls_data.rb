class CreateXlsData < ActiveRecord::Migration
  def change
    create_table :xls_data do |t|
      t.text :ga_url
      t.text :pipeline_url
      t.text :pipeline_name
      t.string :unique_reader
      t.string :stories_read
      t.string :page_session
      t.string :avg_session

      t.timestamps null: false
    end
  end
end
