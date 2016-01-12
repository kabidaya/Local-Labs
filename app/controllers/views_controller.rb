class ViewsController < ApplicationController
  before_filter :require_permissible, :except => [:url_dashboard]

  def index
    @views = View.where(account_id: params[:account_id])
  end

  def new
    @view = View.new(account_id: params[:account_id])
  end

  def show
    @view = View.includes(:account, :mentions).find(params[:id])
    @title = "#{@view.name} | LocalLabs"
    @start_date = (Date.today - 8.days).to_s
    @end_date = (Date.today - 2.days).to_s
  end

  def twitter_profile
    @view = View.includes(:account, :mentions).find(params[:id])
    @start_date = (Date.today - 7.days).to_s
    @end_date = (Date.today - 1.days).to_s
  end

  def create
    @view = View.new(view_params)
    if @view.save
      flash[:notice] = "New View Saved"
      redirect_to account_view_path(@view.account_id, @view)
    else
      flash[:error] = "New View Not Saved"
      render :new
    end
  end

  def edit
    @view = View.find(params[:id])
  end

  def update
    @view = View.find(params[:id])
    if @view.update_attributes(view_params)
      flash[:notice] = "View Updated"
      redirect_to view_path(@view)
    else
      flash[:error] = "View Not Updated"
      render :edit
    end
  end

  def daily_view_metrics
    @view = View.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    start_time = Time.new
    dvm = @view.daily_view_metrics.stats(start_date, end_date)
    page_view_count = @view.daily_view_page_views.no_root.between(start_date, end_date).distinct.count(:permalink)
    dvm[:pages_viewed] = [page_view_count - 1, 0].max
    render json: { daily_view_metrics: dvm }
  end

  def mentions
    start_date = params[:start_date]
    end_date = params[:end_date]

    view = View.find(params[:id])
    mentions = view.mentions.between(params[:start_date], params[:end_date]).to_a
    mentions.map! do |mention|
      mention = mention.attributes
      mention['mention_count'] = Mention.where(user_handle: mention['user_handle']).count
      mention
    end
    mention_data = { twitter_handle: view.twitter_handle, mentions: mentions, mention_count: mentions.count }
    render json: { mention_data: mention_data }
  end

  def dashboard
    start_date = params[:start_date]
    end_date = params[:end_date]
    @view = View.find(params[:id])
    domain_sessions = top_entries("domain",params[:id],@view.summed_network_domain_sessions(start_date, end_date), percentile: 0.001)
    page_views = @view.daily_view_page_views.no_root.between(start_date, end_date).group("permalink").sum(:page_views)
    sites  = page_views.to_a.sort { |a, b| b[1] <=> a[1] }.map{ |pv| pv[0] }[0..19]
    page_views = sites.map { |permalink| { permalink: permalink, page_views: page_views[permalink] } }
    # Visitor Profile (Pie) Data
    users = @view.daily_view_metrics.user_counts(start_date, end_date)
    as = @view.summed_acquisition_sessions(start_date, end_date).map{ |a| { key: a.key.capitalize, value: a.value, pct: a.pct } }
    city = top_entries("city", params[:id], @view.summed_city_sessions(start_date, end_date), pie: true, percentile: 0.001)
    referral = top_entries("referral", params[:id], @view.summed_referral_sessions(start_date, end_date), pie: true, percentile: 0.001)
    # Mention Data
    mentions = @view.mentions.between(params[:start_date],params[:end_date])
    mention_data = { twitter_handle: @view.twitter_handle, mentions: mentions }
    render json: {
      url: @view.url,
      domain_sessions: domain_sessions,
      page_views: page_views,
      visitor_profile: {
        acquisitions: as,
        city: city,
        user_type: users,
        referral: referral
      },
      mention_data: mention_data
    }
  end
  def url_dashboard
    @view= View.find(params[:view_id])
    @name=(params[:c_name]).gsub('%20',' ') if !params[:c_name].nil?
    p @pipeline=NewPipelineApi.where("api_id =?",params[:org_id]).last if !params[:org_id].nil?
    if !params[:start_date].nil? && !params[:end_date].nil? && !params[:url].nil? 
    cookies[:start_date]= params[:start_date] 
    cookies[:end_date]= params[:end_date]
    cookies[:url] = "%#{params[:url]}%" 
    @pipeline=NewPipelineApi.where("name LIKE ?","%#{@name}%").last
    end
    url= @pipeline.url
    uri = URI.parse(url)
    f_url = uri.host.gsub('www.','') 
    url_con ="%#{f_url}%"
    dvm = DailyViewKeyValue.where("date >=  ? AND date <= ? AND key like ? AND view_id = ?", cookies[:start_date], cookies[:end_date], url_con, params[:view_id])
     dvm = {
    user_count: dvm.sum(:user_count),
    session_count: dvm.sum(:session_count),
    new_user_count: dvm.sum(:new_user_count),
    session_duration: dvm.sum(:session_duration),
    page_view_count: dvm.sum(:page_view_count)
    }
    @user_count=dvm[:user_count]
    @page_view_count=dvm[:page_view_count]-1
    @pages_per_session= dvm[:pages_per_session] = dvm[:session_count] > 0 ? (dvm[:page_view_count].to_f / dvm[:session_count]).round(2).to_s : '0'
    duration_secs = dvm[:session_count] > 0 ? dvm[:session_duration] / dvm[:session_count] : 0
    @avg_session_duration = dvm[:avg_session_duration] = duration_secs.seconds_to_minutes
    dvm[:return_user_count] = dvm[:user_count] - dvm[:new_user_count] 
  end

  private
    def top_entries(type, id, collection, args = {})
      percentile =  0.0001
      total_sessions = collection.collect { |d| d.value }.sum
      return_domains = []
      # other = { key: "other", text: "other", sessions: 0, weight: 0, value: 0 }
      ss = []
      collection.each do |ds|
      pct = ds.value.to_f / total_sessions 
        if pct >= percentile && ds.key != "(not set)"
         c_name=NewPipelineApi.where("url=? or url=? or url=? or url=? AND url IS NOT NULL", "https://www.#{ds.key}","http://www.#{ds.key}","http://#{ds.key}", "https://#{ds.key}").last 
         if !c_name.nil?
          ss <<  ds.key
          com_detail= "#{c_name.name}"+"^"+"#{ds.key}"
          entry = { key: com_detail, weight: pct, value: ds.value-5, text: com_detail, sessions: ds.value }
         return_domains << entry
         else
          # com_detail= "#{ds.key}"+"^"+"#{ds.key}"
         end
           ss <<  ds.key
        else
          # other[:weight] += pct
          # other[:sessions] += ds.value
          # other[:value] += ds.value
        end
      end
      # return_domains << other
      return_domains.map{ |a| a.merge(pct: (a[:weight] * 100).to_i) }
    end

    def view_params
      params.require(:view).permit(
        :account_id,
        :logo,
        :name,
        :analytics_id,
        :name,
        :url,
        :twitter_handle,
        :widget_id
      )
    end
end