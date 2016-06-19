class PoemService
  attr_reader :remaining_words

  def initialize(text)
    text ||= ""
    @remaining_words = text.split(" ")
  end

  def get_syllables(desired_num_syllables)
    return nil if @remaining_words.empty?

    words_to_return = _log_around("Getting #{desired_num_syllables}") do
      _get_words(desired_num_syllables)
    end

    words_to_return.join(" ")
  end

  def _get_words(desired_num_syllables)
    words_to_return = []
    num_syllables = 0

    until @remaining_words.empty? do
      word = @remaining_words.shift
      new_syllables =_count_syllables(word)
      if num_syllables + new_syllables <= desired_num_syllables
        words_to_return << word
        num_syllables += new_syllables
      end

      break if num_syllables >= desired_num_syllables
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

  def _log_around(name, &block)
    start_time = Time.now
    Rails.logger.info("Starting #{name}")
    result = block.call
    Rails.logger.info("Finished #{name} after #{Time.now - start_time} seconds")
    result
  end
end
