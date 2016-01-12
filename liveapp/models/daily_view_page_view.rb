class DailyViewPageView < ActiveRecord::Base
  scope :between, ->(d1, d2) { where("date >= ?", Date.parse(d1)).where("date <= ?", Date.parse(d2)) }
  scope :no_root, -> { where(no_root: true) }
end
