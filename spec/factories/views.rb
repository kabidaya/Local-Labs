FactoryGirl.define do
  factory :view do
    account_id 1
    twitter_handle  'twitter'
    analytics_id    12345
    url             'test.com'
    name            'View'
  end
end
