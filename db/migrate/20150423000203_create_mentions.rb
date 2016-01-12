class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :twitter_id
      t.datetime :published_at
      t.text :body
      t.string :user_handle
      t.string :user_image

      t.timestamps null: false
    end

    add_index :mentions, :twitter_id
  end
end
