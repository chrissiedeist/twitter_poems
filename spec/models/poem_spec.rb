require 'rails_helper'

describe Poem do
  it "has a title and body attribute" do
    poem = Poem.new("Cool title", "Poem body. Very Poetic")

    expect(poem.title).to eq("Cool title")
    expect(poem.body).to eq("Poem body. Very Poetic")
  end
end
