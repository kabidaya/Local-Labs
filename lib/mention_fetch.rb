require 'twitter'

class MentionFetch
  def self.search(views, twitter_id = nil)
    client = self.client
    q = views.map { |v| "@#{v.twitter_handle}" }.join(" OR ")
    twitter_id.present? ? client.search(q, since_id: twitter_id) : client.search(q)
  end

  def self.client
    # Twitter::REST::Client.new do |config|
    #   config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
    #   config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
    # end
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "d4PW19f2yJOeCv4tsLDyTWkGs"
      config.consumer_secret     = "9scRvhnkagKIEjW5uOBifyvIZzN7pQtCZ0ufTzdxGPubcnrBVG"
    end
  end
end
