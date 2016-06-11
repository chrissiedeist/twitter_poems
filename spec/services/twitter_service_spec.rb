require('rails_helper')

describe TwitterService do
  describe "self.text_from_query" do
    before(:each) do
      @twitter_service = TwitterService.new
    end

    it "returns the text from tweets returned from a search" do
      result = @twitter_service.text_from_query("ruby")
      expect(result.downcase).to match(/ruby/)
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
    end
  end
end


