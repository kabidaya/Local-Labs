class NewColumnUpdates < ActiveRecord::Migration
  def up
    DailyViewPageView.where("permalink = '/' or permalink LIKE '%?%'").update_all(no_root: false)
    DailyViewKeyValue.where("key = '(not set)' or key = 'unknown.unknown'").update_all(known: false)
  end
end
