require 'rails_helper'

describe View do
  let(:view) { FactoryGirl.create(:view) }
  before do
    view.date = Date.today
  end

  describe "#save_city_sessions" do
    it "creates a City Session record for each element" do
      view.city_sessions = [["Chicago", 10], ["Toronto", "15"]]
      expect{
        view.save_city_sessions
      }.to change { view.daily_view_key_values.city.count }.by(2)
    end
  end

  describe "#save_page_views" do
    it "creates a Page View record for each element" do
      view.page_views = [["/test", '12'], ["/other", "15"]]
      expect{
        view.save_page_views
      }.to change { view.daily_view_page_views.count }.by(2)
    end
  end

  describe "#save_referral_sessions" do
    it "creates a Referral Session record for each element" do
      view.referral_sessions = [["disqus.com", "1"],["en.m.wikipedia.org", "3"],["en.wikipedia.org", "4"]]
      expect{
        view.save_referral_sessions
      }.to change { view.daily_view_key_values.referral.count }.by(3)
    end
  end

  describe "#save_network_domain_sessions" do
    it "creates a Network Domain Session record for each element" do
      view.network_domain_sessions = [["(not set)", "45"], ["14-tataidc.co.in", "2"], ["albertsons.com", "1"]]
      expect{
        view.save_network_domain_sessions
      }.to change { view.daily_view_key_values.network_domain.count }.by(3)
    end
  end

  describe "#save_acquisition_sessions" do
    it "creates a Acquisition Session record for each element" do
      view.acquisition_sessions = [["direct", 36], ["organic", 145], ["referral", 12], ["social", 4]]
      expect{
        view.save_acquisition_sessions
      }.to change { view.daily_view_key_values.acquisition.count }.by(4)
    end
  end

  describe "#save_aggregate" do
    let(:aggregate) { ["1","2","3","4","5"] }

    before do
      view.aggregate = aggregate
    end

    describe "new day" do
      it "creates a new DailyViewMetric record" do
        expect{
          view.save_aggregate
        }.to change{ DailyViewMetric.count }.by(1)
      end
    end

    describe "rewrite a day" do
      it "does not create a new DailyViewMetric record" do
        FactoryGirl.create(:daily_view_metric, view_id: view.id)
        expect{
          view.save_aggregate
        }.not_to change{ DailyViewMetric.count }
      end
    end
  end
end
