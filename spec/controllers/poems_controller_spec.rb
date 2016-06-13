require 'rails_helper'

RSpec.describe PoemsController, type: :controller do
  describe "create" do
    it "creates a new Poem" do
      allow(TwitterService).to receive(:text_from_query).and_return("tweeted stuff")

      post :create, :query => "ruby"

      expect(response).to have_http_status(:created)
      poem = assigns(:poem)
      expect(poem).to be_a(Poem)
    end

    it "handles authentication error from Twitter" do
      TwitterService.stub(:text_from_query).and_raise(Twitter::Error::BadRequest)

      post :create, :query => "ruby" 

      expect(response).to render_template(:error)
      expect(flash[:error]).to include(TwitterService::BAD_REQUEST_MESSAGE)
    end

    it "handles rate limiting errors from Twitter" do
      TwitterService.stub(:text_from_query).and_raise(Twitter::Error::TooManyRequests)

      post :create, :query => "ruby" 

      expect(response).to render_template(:error)
      expect(flash[:error]).to include(TwitterService::RATE_LIMIT_ERROR_MESSAGE)
    end
  end
end
