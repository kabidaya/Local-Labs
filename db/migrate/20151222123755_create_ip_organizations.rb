class CreateIpOrganizations < ActiveRecord::Migration
  def change
    create_table :ip_organizations do |t|
      t.text :api_id
      t.text :name
      t.text :url
      t.text :ip

      t.timestamps null: false
    end
  end
end
