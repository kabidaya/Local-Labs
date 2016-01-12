class IndexOnViewAndDate < ActiveRecord::Migration
  def change
    add_index :daily_view_metrics, [:view_id, :date]
  end
end
