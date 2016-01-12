class ChangeLogoUrlToLogo < ActiveRecord::Migration
  def up
    rename_column :views, :logo_url, :logo
  end

  def down
    rename_column :views, :logo, :logo_url
  end
end
