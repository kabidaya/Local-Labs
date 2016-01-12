class AddAccountIdToViews < ActiveRecord::Migration
  def change
    add_column :views, :account_id, :integer
  end
end
