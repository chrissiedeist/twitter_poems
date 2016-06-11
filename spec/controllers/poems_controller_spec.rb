require 'rails_helper'

RSpec.describe PoemsController, type: :controller do
  describe "create" do
    it "creates a new Poem" do
      allow_any_instance_of(TwitterService).to receive(:text_from_query).and_return("tweeted stuff")
      post :create, :query => "#ruby" 

      expect(response).to have_http_status(:created)
      poem = assigns(:poem)
      expect(poem).to be_a(Poem)
    end
  end
end
