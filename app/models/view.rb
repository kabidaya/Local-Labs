class View < ActiveRecord::Base
  belongs_to :account
  has_many :daily_view_metrics
  has_many :daily_view_key_values
  has_many :daily_view_page_views
  has_many :mention_views
  has_many :mentions, through: :mention_views
  after_create :mention_pull

  validates_presence_of :analytics_id, :url

  mount_uploader :logo, LogoUploader

  attr_accessor :date, :page_views, :city_sessions, :aggregate,
    :acquisition_sessions, :referral_sessions, :network_domain_sessions

  scope :with_twitter, -> { where("twitter_handle IS NOT NULL") }

  def self.pull_all
    ending = Date.today - 1
    puts "Ending date: #{ending.to_s}"
    # @all_view=View.where("id!=?",10)
    all_view=View.all.order( 'id ASC' )
    all_view.each do |view|
    #self.all.each do |view|
    beginning = Date.parse(view.daily_view_metrics.any? ? (view.daily_view_metrics.order("date DESC").first.date + 1).to_s : "2014-10-01")
    #beginning = Date.parse("2014-10-01") 
      next if beginning >= ending
      (beginning..ending).each do |day|
        view.get_analytics(day)
        view.save_analytics
      end
    end
  end

  def self.get_mentions(views = nil)
    views ||= View.with_twitter
    tweets = MentionFetch.search(views, Mention.pluck(:twitter_id).max)
    tweets.each do |tweet|
      mention = Mention.where(user_name: tweet.user.name, twitter_id: tweet.id, published_at: tweet.created_at, body: tweet.full_text, user_handle: tweet.user.screen_name, user_image: tweet.user.profile_image_url.to_s).first_or_create
      views.each do |view|
        view.mentions << mention if mention.body.downcase.include?(view.twitter_handle.downcase)
      end
    end
  end

  def mention_pull
    return unless twitter_handle
    tweets = MentionFetch.search(View.where(id: id))
    tweets.each do |tweet|
      mention = Mention.where(user_name: tweet.user.name, twitter_id: tweet.id, published_at: tweet.created_at, body: tweet.full_text, user_handle: tweet.user.screen_name, user_image: tweet.user.profile_image_url.to_s).first_or_create
      mentions << mention if mention.body.downcase.include?(twitter_handle.downcase)
    end
  end

  def to_s
    name
  end

  def get_analytics(date_string)
    @date = date_string.class == Date ? date_string : Date.parse(date_string)
    ac = AnalyticsCall.new(date, analytics_id)
    puts "View #{id}: #{date}"

    #ga:sessions,ga:users,ga:newUsers,ga:pageviews,ga:timeOnPage
    @aggregate = ac.fetch_aggregate.first

    #[["url","view count string"]...[]]
    @page_views = ac.fetch_views_by_page

    # [["Chicago", "34"]...]
    @city_sessions = ac.fetch_sessions_by_city

    # [["direct", 36], ["organic", 145], ["referral", 12], ["social", 4]]
    @acquisition_sessions = ac.fetch_acquisition_sessions

    # [["disqus.com", "1"],["en.m.wikipedia.org", "3"],["en.wikipedia.org", "4"]]
    @referral_sessions = ac.fetch_referral_sessions

    # [["(not set)", "45"], ["14-tataidc.co.in", "2"], ["albertsons.com", "1"]]
    @network_domain_sessions = ac.fetch_visitor_domain_sessions
  end

  def save_analytics
    save_aggregate
    save_city_sessions
    save_acquisition_sessions
    save_referral_sessions
    save_network_domain_sessions
    save_page_views
  end

  def save_page_views
    page_views.each do |pv|
      dpv = daily_view_page_views.where(permalink: pv[0], date: date).first_or_initialize
      dpv.update_attributes(page_views: pv[1].to_i, no_root: pv[0] != "(not set)" && pv[0] != "unknown.unknown" )
    end
  end
  ['city', 'acquisition', 'referral', 'network_domain'].each do |cat|
    define_method("save_#{cat}_sessions") do
      self.send("#{cat}_sessions").each do |record|
        meta = daily_view_key_values.send(cat).where(date: date, key: record[0]).first_or_initialize
        # meta.update_attributes(page_view_count: record[4].to_i, user_count: record[2].to_i, new_user_count: record[3].to_i, session_count: record[1].to_i, session_duration: record[5].to_i, value: record[1].to_i, known: record[0] != "/" && !record[0].include?("?"))
         if (cat=='network_domain')
             meta.update_attributes(page_view_count: record[4].to_i, user_count: record[2].to_i, new_user_count: record[3].to_i, session_count: record[1].to_i, session_duration: record[5].to_i, value: record[1].to_i, known: record[0] != "/" && !record[0].include?("?"))
         else
             meta.update_attributes(value: record[1].to_i, known: record[0] != "/" && !record[0].include?("?"))
         end
      end
    end

    define_method("summed_#{cat}_sessions") do |start_date, end_date|
      dvkv = daily_view_key_values.send(cat.to_sym).between(start_date, end_date).group("key").select("key, SUM(value) AS value")
      dvkv = dvkv.known if cat == "network_domain"
      total = dvkv.collect{ |d| d.value }.sum
      dvkv.each { |d| d.pct = ((d.value.to_f / total) * 100).to_i } unless total == 0
      dvkv
    end
  end

  def save_aggregate
    #ga:sessions,ga:users,ga:newUsers,ga:pageviews,ga:timeOnPage
    dvm = daily_view_metrics.where(date: date).first_or_initialize
    dvm.update_attributes(
      page_view_count: aggregate[3].to_i,
      user_count: aggregate[1].to_i,
      new_user_count: aggregate[2].to_i,
      return_user_count: aggregate[1].to_i - aggregate[2].to_i,
      session_count: aggregate[0].to_i,
      session_duration: aggregate[4].to_i
    )
  end
  
end
