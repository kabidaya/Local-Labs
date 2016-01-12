class CreateMentionViews < ActiveRecord::Migration
  def change
    create_table :mention_views do |t|
      t.integer :mention_id, null: false
      t.integer :view_id, null: false

      t.timestamps null: false
    end

    add_index :mention_views, :view_id
  end
end
