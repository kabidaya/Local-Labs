class DailyViewKeyValue < ActiveRecord::Base
  belongs_to :view

  scope :city, -> { where(category: "City") }
  scope :acquisition, -> { where(category: "Acquisition") }
  scope :referral, -> { where(category: "Referral") }
  scope :network_domain, -> { where(category: "NetworkDomain") }
  scope :between, ->(d1, d2) { where("date >= ?", Date.parse(d1)).where("date <= ?", Date.parse(d2)) }
  scope :known, -> { where(known: true) }

  attr_accessor :pct
end
