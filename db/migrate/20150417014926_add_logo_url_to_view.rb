class AddLogoUrlToView < ActiveRecord::Migration
  def change
    add_column :views, :logo_url, :text
  end
end
