module TwitterHelper
  TWITTER_CLIENT_CONFIG = {
     :consumer_key => ENV['CONSUMER_KEY'],
     :consumer_secret => ENV['CONSUMER_SECRET'],
     :bearer_token => ENV['BEARER_TOKEN'],
  }

  def self.authenticated_twitter_client
    Twitter::REST::Client.new(TWITTER_CLIENT_CONFIG)
  end
end
