class Poem
  attr_reader :topic, :raw_text

  DEFAULT_HAIKU = "Sorry, there are not\nEnough tweets about that word\nTry another one\n"

  def initialize(topic, raw_text)
    @topic = topic
    @service = PoemService.new(raw_text)
    @raw_text = raw_text
  end

  def to_haiku
    return DEFAULT_HAIKU unless @raw_text.present?

    first_line = @service.get_syllables(5).try(:humanize)
    second_line = @service.get_syllables(7).try(:humanize)
    third_line = @service.get_syllables(5).try(:humanize)

    [first_line, second_line, third_line].join("\n")
  end
end
