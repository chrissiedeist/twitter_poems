class TwitterService
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  def text_from_query(query)
    query.sub(/#/, '')
    results = @client.search("##{query}", count: 20) 

    text = results.map(&:text).map do |text| 
      text = _remove_url(text)
      text = _remove_retweet(text)
      _remove_handles(text)
    end.join("")
  end

  def _remove_url(tweet)
    tweet.gsub(/http\S*/, '')
  end

  def _remove_retweet(tweet)
    tweet.sub(/^RT .*: /, '')
  end

   def _remove_handles(tweet)
     tweet.gsub(/@\S*/, '')
   end
end
