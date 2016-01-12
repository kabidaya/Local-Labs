class RemoveProperties < ActiveRecord::Migration
  def up
    View.all.each do |view|
      next if view.account_id
      view.account_id = Property.find(view.property_id).account_id
      view.save
    end
  end
end
