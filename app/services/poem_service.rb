class PoemService
  attr_reader :text, :remaining_words

  def initialize(text)
    @text = text
    @remaining_words = text.split(" ")
  end

  def get_syllables(desired_num_syllables)
    words_to_return = []
    num_syllables = 0

    @remaining_words.each do |word|
      new_syllables = _count_syllables(word)
      if num_syllables + new_syllables <= desired_num_syllables
        words_to_return << word
        num_syllables += new_syllables
      end

      break if num_syllables >= desired_num_syllables
    end

    @remaining_words = @remaining_words - words_to_return

    if (missing_syllables = desired_num_syllables - num_syllables) != 0
      words_to_return = _pad_syllables(words_to_return, missing_syllables)
    end

    words_to_return.join(" ")
  end

  def _pad_syllables(words_to_return, missing_syllables)
    pad_syllable = "hm"
    missing_syllables.times do
      words_to_return << pad_syllable 
    end
    words_to_return
  end

  def _count_syllables(word)
    word = word.downcase
    return 1 if word.length <= 3

    word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    word.sub!(/^y/, '')
    word.scan(/[aeiouy]{1,2}/).size
  end
end
