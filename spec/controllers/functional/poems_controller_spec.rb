require 'rails_helper'

RSpec.describe PoemsController, type: :controller do
  describe "create" do
    it "creates a new Poem with the results from the Twitter service" do
      allow(TwitterService).to receive(:text_from_query).with("ruby").and_return("tweeted stuff")

      post :create, :query => "ruby"

      expect(response).to have_http_status(:created)

      poem = assigns(:poem)
      expect(poem.to_haiku).to be_a(String)
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

  describe "new" do
    it "assigns the result of the Twitter service to @trending_topics" do
      trending_results = ["hottopic", "Also super hot topic"]
      allow(TwitterService).to receive(:trending_topics).and_return(trending_results)

      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new) 

      trending_topics = assigns(:trending_topics)
      expect(trending_topics).to eq(trending_results)
    end
  end
end
