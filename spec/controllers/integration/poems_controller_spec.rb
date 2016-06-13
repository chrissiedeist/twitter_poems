require 'rails_helper'

RSpec.describe PoemsController, type: :request do
  describe "create" do
    it "creates a new Poem" do
      post '/poems', :query => "ruby"

      expect(response).to have_http_status(:created)

      poem = assigns(:poem)
      expect(poem.to_haiku).to be_a(String)
      expect(poem.topic).to eq("ruby")
    end
  end

  describe "new" do
    it "returns an array of trending topics from twitter" do
      Rails.cache.delete("trending_topics")
      get '/poems/new'

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new) 

      trending_topics = assigns(:trending_topics)
      expect(trending_topics).to be_an(Array)
      expect(trending_topics.first).to be_a(String)
    end
  end
end
