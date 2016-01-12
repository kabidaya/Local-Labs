require 'google/api_client'

class AnalyticsCall
  attr_accessor :client, :date, :profile

  def initialize(date, analytics_id)
    #keypath = Rails.root.join('config','client.p12').to_s
    keypath = 'lib/p12/LocalLabs-8b9318424e39.p12'
    @client = Google::APIClient.new
    # @client.authorization = Signet::OAuth2::Client.new(
    #   token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
    #   audience:             'https://accounts.google.com/o/oauth2/token',
    #   scope:                'https://www.googleapis.com/auth/analytics.readonly',
    #   issuer:               ENV['SERVICE_ACCOUNT_EMAIL_ADDRESS'],
    #   signing_key:          Google::APIClient::PKCS12.load_key(ENV['PATH_TO_KEY_FILE'], 'notasecret')
    # ).tap { |auth| auth.fetch_access_token! }
   @client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience:             'https://accounts.google.com/o/oauth2/token',
      scope:                'https://www.googleapis.com/auth/analytics.readonly',
      issuer:               '328252131722-5cqnjnijj4lj33vbbeamqr35kn9g38po@developer.gserviceaccount.com',
      signing_key:          Google::APIClient::PKCS12.load_key(keypath, 'notasecret')
    ).tap { |auth| auth.fetch_access_token! }
    @api_method = @client.discovered_api('analytics','v3').data.ga.get
    @date = date.to_s
    @profile = "ga:#{analytics_id}"
  end

  def fetch_aggregate
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'metrics'    => 'ga:sessions,ga:users,ga:newUsers,ga:pageviews,ga:timeOnPage'
    }
    call_api(params)
  end

  def fetch_sessions_by_city
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'dimensions' => 'ga:city',
       'metrics'    => 'ga:sessions'
    }
    call_api(params)
  end

  def fetch_views_by_page
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'dimensions' => 'ga:pagePath',
       'metrics'    => 'ga:pageviews'
    }
    call_api(params)
  end

  def fetch_referral_sessions
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'dimensions' => 'ga:source',
       'filters'    => 'ga:medium==referral',
       'metrics'    => 'ga:sessions'
    }
    call_api(params)
  end

  def fetch_visitor_domain_sessions
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'dimensions' => 'ga:networkDomain',
       # 'metrics'    => 'ga:sessions'
       'metrics'    => 'ga:sessions,ga:users,ga:newUsers,ga:pageviews,ga:timeOnPage'
    }
    call_api(params)
  end

  def fetch_acquisition_sessions
    params = {
       'ids'        => @profile,
       'start-date' => @date,
       'end-date'   => @date,
       'dimensions' => 'ga:medium',
       'metrics'    => 'ga:sessions'
    }
    base = call_api(params)
    params['dimensions'] = 'ga:hasSocialSourceReferral'
    social = call_api(params)
    base << social.select{ |a| a[0] == 'Yes' }.first
    base.compact!
    base = base.map do |source|
      case source[0]
      when '(none)'
        ["direct", source[1].to_i]
      when 'referral'
        begin
          ['referral', source[1].to_i - (base.select{ |b| b[0] == 'Yes' }.any? ? base.select{ |b| b[0] == 'Yes' }[0][1].to_i : 0)]
        rescue NoMethodError => e
          puts e
          ['referral', source[1].to_i]
        end
      when 'Yes'
        ['social', source[1].to_i]
      else
        [source[0], source[1].to_i]
      end
    end

    return base
  end

  private
    def call_api(params)
      result = @client.execute(api_method: @api_method, parameters: params)
      return JSON.parse(result.data.rows.inspect)
    end
end


