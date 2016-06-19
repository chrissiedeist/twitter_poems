require('rails_helper')

describe TwitterService do
  describe "self.trending_topics" do
    before(:each) do 
      Rails.cache.delete("trending_topics")
    end

    it "maps the trend results to an array of names" do
      result = TwitterService.trending_topics
      expect(result).to be_an(Array)
    end

    it "does not blow up if there are no results" do
      expect_any_instance_of(Twitter::REST::Client).to receive(:trends).and_return nil

      results = nil
      expect do
        results = TwitterService.trending_topics
      end.to_not raise_error

      expect(results).to eq([])
    end

    it "caches the results" do
      expect_any_instance_of(Twitter::REST::Client).to receive(:trends).exactly(:once)
      TwitterService.trending_topics
      TwitterService.trending_topics
    end
  end

  describe "self.text_from_query" do
    it "returns the text from tweets returned from a search" do
      tweet_1 = { :text => "Saturday’s Pet of the Day is #fun" }
      tweet_2 = { :text => "Fun fun fun!" }
      allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet_1, tweet_2])

      result = TwitterService.text_from_query("fun")
      expect(result).to match("Saturday’s Pet of the Day is #funFun fun fun!")
    end

    it "does not raise an error if the query is an empty string" do
      expect do
        TwitterService.text_from_query("")
      end.to_not raise_error
    end

    it "returns nil if there are no results from twitter" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).and_return nil

        result = TwitterService.text_from_query("xasdfasdgagds")
        expect(result).to be_nil
    end

    it "adds a # in front of the query if it doesn't contain one" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).with("#fun", {:count => TwitterService::NUM_TWEETS_TO_FETCH })

        TwitterService.text_from_query("fun")
    end

    it "does not add an extra # in front of the query if already contains one" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).with("#fun", {:count => TwitterService::NUM_TWEETS_TO_FETCH})

        TwitterService.text_from_query("#fun")
    end

    context "when tweets contain unwanted text" do
      it "removes urls from text" do
        tweet = { :text => "Saturday’s Pet of the Day is #fun Tiki-a #pineapple #conure -talk of him\nhttps://t.co/3S54PjvAne\n#petoftheday #pets https://t.co/j26c0cUwqw" }

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = TwitterService.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/http/)
      end

      it "removes retweet portion of tweet" do
        tweet = { :text => "RT @twitterhandle: Saturday’s Pet of the Day is so fun https://t.co/3S54PjvAne\n#petoftheday #pets https://t.co/j26c0cUwqw" }

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = TwitterService.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/^RT/)
      end

      it "removes twitter handles" do
        tweet = { :text => "@twitterhandle: Saturday’s Pet of the Day is so fun @anotherhandle" }

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = TwitterService.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/@/)
      end

      it "removes digits" do
        tweet = { :text => "@twitterhandle: 999 Saturday’s Pet of the Day is so fun @anotherhandle" }

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = TwitterService.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/999/)
      end
    end
  end
end


