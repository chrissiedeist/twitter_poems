module TwitterHelper
  TWITTER_CLIENT_CONFIG = {
     :consumer_key => ENV['CONSUMER_KEY'],
     :consumer_secret => ENV['CONSUMER_SECRET'],
     :access_token => ENV['ACCESS_TOKEN'],
     :access_token_secret => ENV['ACCESS_TOKEN_SECRET'],
  }

  def self.authenticated_twitter_client
    Twitter::REST::Client.new(TWITTER_CLIENT_CONFIG)
  end
end
