class Mention < ActiveRecord::Base
  has_many :mention_views, dependent: :destroy
  validates_uniqueness_of :twitter_id
  default_scope { order("published_at DESC") }

  def self.between(start_date, end_date)
    where("published_at >= ? AND published_at <= ?", Date.parse(start_date), Date.parse(end_date))
  end

end
