class TwitterService
  REGEXES_TO_REMOVE_FROM_TEXT = {
    :urls => /http\S*/,
    :retweet => /^RT .*: /,
    :handles => /@\S*/,
    :numbers => /\d/,
  }

  NUM_TWEETS_TO_FETCH = 10
  WOEID = 1 # Global 'where on earth location' ID

  RATE_LIMIT_ERROR_MESSAGE = "You've hit Twitter rate limits! Come back in 15 minutes."
  BAD_REQUEST_MESSAGE = "Something went wrong with the request to Twitter. Try another topic"
  UNAUTHORIZED_MESSAGE = "Looks like the application's twitter credentials are no longer valid. Email the developer at chrissie.deist@gmail.com."

  def self.trending_topics
    results = Rails.cache.fetch("trending_topics", expires_in: 15.minutes) do
      TwitterHelper.authenticated_twitter_client.trends(id=WOEID, options = {})
    end

    results ? results.map(&:name) : []
  end

  def self.text_from_query(query)
    return nil unless query.present?

    query = _add_hashtag_if_missing(query)

    results = _get_raw_results(query)

    return nil unless results

    _get_cleaned_text(results)
  end

  def self._get_raw_results(query) 
    TwitterHelper.authenticated_twitter_client
      .search(query, count: NUM_TWEETS_TO_FETCH) 
  end

  def self._add_hashtag_if_missing(query)
    query.match(/^#/) ? query : "##{query}"
  end

  def self._get_cleaned_text(results)
    results.take(NUM_TWEETS_TO_FETCH).map do |tweet|
      _remove_unwanted_text(tweet.text)
    end.join("")
  end

  def self._remove_unwanted_text(tweet)
    regex = Regexp.union(REGEXES_TO_REMOVE_FROM_TEXT.values)

    tweet.gsub(regex, '')
  end
end
