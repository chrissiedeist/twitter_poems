class TwitterService
  REGEXES_TO_REMOVE_FROM_TEXT = {
    :urls => /http\S*/,
    :retweet => /^RT .*: /,
    :handles => /@\S*/,
    :numbers => /\d/,
  }

  NUM_TWEETS_TO_FETCH = 20

  def self.text_from_query(query)
    results = _get_raw_results(query)

    return nil unless results

    _get_cleaned_text(results)
  end

  def self._get_raw_results(query) 
    query = _add_hashtag_if_missing(query)

    TwitterHelper.authenticated_twitter_client
      .search(query, count: NUM_TWEETS_TO_FETCH) 
  end

  def self._add_hashtag_if_missing(query)
    query.match(/^#/) ? query : "##{query}"
  end

  def self._get_cleaned_text(results)
    results.map(&:text).map do |text| 
      _remove_unwanted_text(text)
    end.join("")
  end

  def self._remove_unwanted_text(tweet)
    regex = Regexp.union(REGEXES_TO_REMOVE_FROM_TEXT.values)

    tweet.gsub(regex, '')
  end
end
