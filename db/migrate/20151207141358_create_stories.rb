class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :story_id
      t.text :organization_id
      t.integer :community_id
      t.date :published_at
      t.integer :type_id
      t.text :headline
      t.text :author
      t.boolean :published
      t.boolean :paid
      t.integer :p_no
      t.timestamps null: false
    end
  end
end



