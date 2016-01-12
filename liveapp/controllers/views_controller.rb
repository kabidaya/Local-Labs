class ViewsController < ApplicationController
  before_filter :require_permissible

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

    domain_sessions = top_entries(@view.summed_network_domain_sessions(start_date, end_date), percentile: 0.001)

    page_views = @view.daily_view_page_views.no_root.between(start_date, end_date).group("permalink").sum(:page_views)
    sites  = page_views.to_a.sort { |a, b| b[1] <=> a[1] }.map{ |pv| pv[0] }[0..19]
    page_views = sites.map { |permalink| { permalink: permalink, page_views: page_views[permalink] } }

    # Visitor Profile (Pie) Data
    users = @view.daily_view_metrics.user_counts(start_date, end_date)
    as = @view.summed_acquisition_sessions(start_date, end_date).map{ |a| { key: a.key.capitalize, value: a.value, pct: a.pct } }
    city = top_entries(@view.summed_city_sessions(start_date, end_date), pie: true, percentile: 0.001)
    referral = top_entries(@view.summed_referral_sessions(start_date, end_date), pie: true, percentile: 0.001)

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

  private
    
    def top_entries(collection, args = {})
      percentile = args[:percentile] || 0.01
      total_sessions = collection.collect { |d| d.value }.sum
      return_domains = []
      other = { key: "other", text: "other", sessions: 0, weight: 0, value: 0 }
      collection.each do |ds|
        pct = ds.value.to_f / total_sessions 
        if pct >= percentile && ds.key != "(not set)"
          entry = { key: ds.key, weight: pct, value: ds.value, text: ds.key, sessions: ds.value }
          return_domains << entry
        else
          other[:weight] += pct
          other[:sessions] += ds.value
          other[:value] += ds.value
        end
      end
      return_domains << other
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
