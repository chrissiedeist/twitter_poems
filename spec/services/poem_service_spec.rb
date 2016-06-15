require 'rails_helper'

describe PoemService do
  it "keeps track of the full text and the words that have not yet been used" do
    example_text = "Some text to create a poem"

    poem_service = PoemService.new(example_text)
    expect(poem_service.remaining_words).to eq(["Some", "text", "to", "create", "a", "poem"])
  end

  describe "get_syllables" do
    context "when the words break naturally at the desired number of syllables" do
      it "returns an array of words with the specified number of syllables" do
        easy_sample_text = "An old silent pond contained many frogs"
        poem_service = PoemService.new(easy_sample_text)
        expect(poem_service.get_syllables(5)).to eq("An old silent pond")
      end

      it "removes the returned syllables from the remaining_word arrary" do
        easy_sample_text = "An old silent pond contained many frogs"
        poem_service = PoemService.new(easy_sample_text)

        poem_service.get_syllables(5)

        expect(poem_service.remaining_words).to eq(["contained", "many", "frogs"])
      end
    end

    context "when the words do not break naturally at the desired number of syllables" do
      it "looks for the next word that has the desired number of syllables" do
        uneven_sample_text = "An old silent farmer went to the store"
        poem_service = PoemService.new(uneven_sample_text)

        expect(poem_service.get_syllables(5)).to eq("An old silent went")
        expect(poem_service.remaining_words).to eq(["to", "the", "store"])
      end
    end

    context "when there are insufficient syllables in the given text" do
      it "returns as many syllables as it can and then nil" do
        easy_sample_text = "An old silent pond contained many frogs"
        poem_service = PoemService.new(easy_sample_text)

        expect(poem_service.get_syllables(5)).to eq("An old silent pond")
        expect(poem_service.get_syllables(7)).to eq("contained many frogs")
        expect(poem_service.get_syllables(7)).to eq(nil)
      end
    end

    context "when initialized with a nil" do
      it "returns nil" do
        text = nil
        poem_service = PoemService.new(text)
        expect(poem_service.get_syllables(5)).to eq(nil)
      end
    end

    context "when initialized with an empty string" do
      it "returns nil" do
        poem_service = PoemService.new("")
        expect(poem_service.get_syllables(5)).to eq(nil)
      end
    end
  end
end
