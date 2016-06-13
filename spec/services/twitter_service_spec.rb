require('rails_helper')

describe TwitterService do
  before(:each) do
    @twitter_service = TwitterService
  end

  describe "self.trending_topics" do
    it "returns an array of trending topics" do
      result = @twitter_service.trending_topics
      expect(result).to be_an Array
    end

    it "does not blow up if there are no results" do
      Rails.cache.delete("trending_topics")
      expect_any_instance_of(Twitter::REST::Client).to receive(:trends).and_return nil

      expect do
        @twitter_service.trending_topics
      end.to_not raise_error
    end

    it "caches the results" do
      Rails.cache.delete("trending_topics")
      expect_any_instance_of(Twitter::REST::Client).to receive(:trends).exactly(:once)
      @twitter_service.trending_topics
      @twitter_service.trending_topics
    end
  end

  describe "self.text_from_query" do
    it "returns the text from tweets returned from a search" do
      result = @twitter_service.text_from_query("ruby")
      expect(result).to match(/ruby/i)
    end

    it "does not raise an error if the query is an empty string" do
      expect do
        @twitter_service.text_from_query("")
      end.to_not raise_error
    end

    it "returns nil if there are no results from twitter" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).and_return nil

        result = @twitter_service.text_from_query("xasdfasdgagds")
        expect(result).to be_nil
    end

    it "adds a # in front of the query if it doesn't contain one" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).with("#fun", {:count => 20 })

        @twitter_service.text_from_query("fun")
    end

    it "does not add an extra # in front of the query if already contains one" do
        expect_any_instance_of(Twitter::REST::Client).to receive(:search).with("#fun", {:count => 20})

        @twitter_service.text_from_query("#fun")
    end

    context "when tweets contain unwanted text" do
      it "removes urls from text" do
        tweet = double(:text => "Saturday’s Pet of the Day is #fun Tiki-a #pineapple #conure -talk of him\nhttps://t.co/3S54PjvAne\n#petoftheday #pets https://t.co/j26c0cUwqw")

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = @twitter_service.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/http/)
      end

      it "removes retweet portion of tweet" do
        tweet = double(:text => "RT @twitterhandle: Saturday’s Pet of the Day is so fun https://t.co/3S54PjvAne\n#petoftheday #pets https://t.co/j26c0cUwqw")

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = @twitter_service.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/^RT/)
      end

      it "removes twitter handles" do
        tweet = double(:text => "@twitterhandle: Saturday’s Pet of the Day is so fun @anotherhandle")

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = @twitter_service.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/@/)
      end

      it "removes digits" do
        tweet = double(:text => "@twitterhandle: 999 Saturday’s Pet of the Day is so fun @anotherhandle")

        allow_any_instance_of(Twitter::REST::Client).to receive(:search).and_return([tweet])

        result = @twitter_service.text_from_query("fun")

        expect(result.downcase).to match(/fun/)
        expect(result.downcase).to_not match(/999/)
      end
    end
  end
end


