require 'rails_helper'

describe Poem do
  it "it initialized with raw text and a topic" do
    poem = Poem.new("music", "Twitter text about music. Musicky-music music music")

    expect(poem.raw_text).to eq("Twitter text about music. Musicky-music music music")
    expect(poem.topic).to eq("music")
  end

  describe "to_haiku" do
    it "returns the body of the poem in the form of a haiku" do
      raw_text = <<-TWITTER_TEXT
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.= 
      TWITTER_TEXT

      poem = Poem.new("Lorem", raw_text)

      haiku = <<-HAIKU
Lorem ipsum sit
Dolor amet, elit, sed
Consectetur do 
      HAIKU

      expect(poem.to_haiku).to eq(haiku.strip)
    end

    it "returns an apology haiku if given no raw text" do
      poem = Poem.new("obscurethingthatdoesntgettweetedabout", "")

      expect(poem.to_haiku).to eq(Poem::DEFAULT_HAIKU)
    end

    it "returns an partial haiku if there is insufficient raw data to create a real one" do
      poem = Poem.new("obscurethingthatdoesntgettweetedabout", "Some text, but not really enough")

      haiku = "Some text, but not\nReally enough\n"
      expect(poem.to_haiku).to eq(haiku)
    end
  end
end
