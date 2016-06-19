class TwitterHelper
  BASE_URI = "https://api.twitter.com"
  TWITTER_CLIENT_CONFIG = {
     :consumer_key => ENV['CONSUMER_KEY'],
     :consumer_secret => ENV['CONSUMER_SECRET'],
  }

  def initialize
    @connection = Faraday.new(:url => BASE_URI) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    @bearer_token ||= get_bearer_token
  end

  def search(query, options)
    count = 100 || options[:count]
    bearer_auth = "Bearer #{@bearer_token}"
    headers = {:authorization => bearer_auth }
    _request(:get, '/1.1/search/tweets.json', {:count => count, :q => query}, headers)
    
  end

  def get_bearer_token
    token = Base64.strict_encode64("#{TWITTER_CLIENT_CONFIG[:consumer_key]}:#{TWITTER_CLIENT_CONFIG[:consumer_secret]}")
    basic_auth ="Basic #{token}"
    headers = {
      :accept         => "*/*",
      :authorization  => basic_auth,
      :content_type   => "application/x-www-form-urlencoded; charset=UTF-8",
    }
    response = _request(:post, "/oauth2/token", {:grant_type => "client_credentials"}, headers)
    JSON.parse(response.body)["access_token"]
  end

  def _request(method, path, params = {}, headers = {})
    @connection.send(method.to_sym, path, params) { |request| request.headers.update(headers) }.env
  rescue Faraday::Error::TimeoutError, Timeout::Error => error
    raise(Twitter::Error::RequestTimeout.new(error))
  rescue Faraday::Error::ClientError, JSON::ParserError => error
    fail(Twitter::Error.new(error))
  end
end
