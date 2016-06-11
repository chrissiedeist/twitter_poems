require 'rails_helper'

RSpec.describe PoemsController, type: :controller do
  describe "create" do
    it "creates a new Poem" do
      post :create, :poem => :twitter_handle

      poem = assigns(:poem)
      expect(poem).to be_a(Poem)

      expect(poem.title).to_not be_nil
      expect(poem.body).to_not be_nil
    end
  end
end
