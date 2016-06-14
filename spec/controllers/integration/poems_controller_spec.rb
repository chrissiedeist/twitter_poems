require 'rails_helper'

RSpec.describe PoemsController, type: :request do
  describe "create" do
    context "when given a valid query" do
      it "creates a new Poem and renders show" do
        post '/poems', :query => "ruby"

        expect(response).to have_http_status(:created)
        expect(response).to render_template(:show)

        poem = assigns(:poem)
        expect(poem.to_haiku).to be_a(String)
        expect(poem.topic).to eq("ruby")
      end
    end

    context "when given a query that Twitter can't process" do
      it "renders an error page" do
        post '/poems', :query => "!!! !!"

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:error)
      end
    end

    context "when given a query that doesn't have enough results" do
      it "returns the default Poem and renders show" do
        post '/poems', :query => "asdf1234asdf1234asdf1234"

        expect(response).to have_http_status(:created)
        expect(response).to render_template(:show)

        poem = assigns(:poem)
        expect(poem.to_haiku).to be_a(String)
        expect(poem.to_haiku).to eq(Poem::DEFAULT_POEMS[:haiku])
      end
    end

    context "when given nil for the query" do
      it "returns the default Poem and renders show" do
        post '/poems', :query => nil

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(:new_poem)
      end
    end

    context "when given a query in foreign characters" do
      it "generates a poem or returns the default Poem and renders show" do
        post '/poems', :query => "#ابي_اتزوج_عراقيh"

        expect(response).to render_template(:show)

        poem = assigns(:poem)
        expect(poem.to_haiku).to be_a(String)
      end
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
