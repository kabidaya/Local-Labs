FactoryGirl.define do
  factory :daily_view_metric do
    view_id           1
    date              Date.today
    page_view_count   200
    user_count        150
    new_user_count    75
    return_user_count 75
    session_count     180
    session_duration  1500
  end
end
