class AddUserNameToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :user_name, :string
  end
end
