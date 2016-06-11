class TwitterService
  REGEXES_TO_REMOVE_FROM_TEXT = {
    :urls => /http\S*/,
    :retweet => /^RT .*: /,
    :handles => /@\S*/,
  }

  NUM_TWEETS_TO_FETCH = 20

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  def text_from_query(query)
    results = _get_raw_results(query)

    return nil unless results

    _get_cleaned_text(results)
  end

  def _get_raw_results(query) 
    query = _add_hashtag_if_missing(query)
    @client.search(query, count: NUM_TWEETS_TO_FETCH) 
  end

  def _add_hashtag_if_missing(query)
    query.match(/^#/) ? query : "##{query}"
  end

  def _get_cleaned_text(results)
    results.map(&:text).map do |text| 
      _remove_unwanted_text(text)
    end.join("")
  end

  def _remove_unwanted_text(tweet)
    regex = Regexp.union(REGEXES_TO_REMOVE_FROM_TEXT.values)

    tweet.gsub(regex, '')
  end
end
