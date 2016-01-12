class DailyViewMetric < ActiveRecord::Base
  belongs_to :view
  scope :between, ->(d1, d2) { where("date >= ?", Date.parse(d1)).where("date <= ?", Date.parse(d2)) }

  def self.user_counts(start_date, end_date)
    dvm = self.between(start_date, end_date)
    dvm = {
      user_count: dvm.sum(:user_count),
      new_user_count: dvm.sum(:new_user_count)
    }
    dvm[:return_user_count] = dvm[:user_count] - dvm[:new_user_count]

    users = [
              { key: "new", value: dvm[:new_user_count] },
              { key: "returning", value: dvm[:return_user_count] }
            ]
    if dvm[:user_count] > 0
      users[0][:pct] = ((dvm[:new_user_count].to_f / dvm[:user_count]) * 100).to_i
      users[1][:pct] = 100 - ((dvm[:new_user_count].to_f / dvm[:user_count]) * 100).to_i
    end
    users
  end

  def self.stats(start_date, end_date)
    dvm = self.between(start_date, end_date)
    dvm = {
      user_count: dvm.sum(:user_count),
      session_count: dvm.sum(:session_count),
      new_user_count: dvm.sum(:new_user_count),
      session_duration: dvm.sum(:session_duration),
      page_view_count: dvm.sum(:page_view_count)
    }
    p dvm
    p dvm[:page_view_count]
   
    dvm[:pages_per_session] = dvm[:session_count] > 0 ? (dvm[:page_view_count].to_f / dvm[:session_count]).round(2).to_s : '0'
    duration_secs = dvm[:session_count] > 0 ? dvm[:session_duration] / dvm[:session_count] : 0
    dvm[:avg_session_duration] = duration_secs.seconds_to_minutes
    dvm[:return_user_count] = dvm[:user_count] - dvm[:new_user_count] 
    p dvm
     # binding.pry
  end
end
