require 'rails_helper'

describe TwitterService do
  describe "self.text_from_query" do
    it "returns the text from tweets returned from a search" do
      result = TwitterService.new.text_from_query("#ruby")

      expect(result.downcase).to match(/ruby/)
    end
  end
end
