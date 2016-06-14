class Poem
  attr_reader :topic, :raw_text

  DEFAULT_POEMS = {
    :haiku => "Sorry, there are not\nEnough tweets about that word\nTry another one\n"
  }

  SYLLABLE_PATTERNS = {
    :haiku => [5, 7, 5]
  }

  def initialize(topic, raw_text)
    @topic = topic
    @service = PoemService.new(raw_text)
    @raw_text = raw_text
  end

  def to_haiku
    _to_type(:haiku)
  end

  def _to_type(type)
    return DEFAULT_POEMS[type] unless @raw_text.present?

    lines = _build_lines_for(type)

    return DEFAULT_POEMS[type] unless _has_enough_lines(type, lines)

    _output(lines)
  end

  def _build_lines_for(type)
    SYLLABLE_PATTERNS[type].map do |syllables_per_line|
      @service.get_syllables(syllables_per_line)
    end.compact
  end

  def _has_enough_lines(type, lines)
    lines.length == SYLLABLE_PATTERNS[type].length
  end

  def _output(lines)
    lines.map(&:humanize).join("\n")
  end
end
