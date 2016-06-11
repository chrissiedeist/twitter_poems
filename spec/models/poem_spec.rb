require 'rails_helper'

describe Poem do
  it "has raw text" do
    poem = Poem.new("Poem body. Very Poetic")

    expect(poem.raw_text).to eq("Poem body. Very Poetic")
  end

  describe "to_haiku" do
    it "returns the body of the poem in the form of a haiku" do
      raw_text = <<-TWITTER_TEXT
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.= 
      TWITTER_TEXT

      poem = Poem.new(raw_text)

      haiku = <<-HAIKU
Lorem ipsum sit
Dolor amet, elit, sed
Consectetur do 
      HAIKU

      expect(poem.to_haiku).to eq(haiku.strip)
    end
  end
end
