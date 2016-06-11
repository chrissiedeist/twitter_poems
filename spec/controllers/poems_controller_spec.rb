require 'rails_helper'

RSpec.describe PoemsController, type: :controller do
  describe "create" do
    it "creates a new Poem" do
      allow_any_instance_of(TwitterService).to receive(:text_from_query).and_return("tweeted stuff")
      post :create, :query => "#ruby" 

      poem = assigns(:poem)
      expect(poem).to be_a(Poem)

      expect(poem.title).to_not be_nil
      expect(poem.body).to eq("tweeted stuff")
    end
  end
end
