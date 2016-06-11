class Poem
  attr_reader :raw_text

  def initialize(raw_text)
    @raw_text = raw_text
  end

  def to_haiku
    service = PoemService.new(@raw_text)

    first_line = service.get_syllables(5).humanize
    second_line = service.get_syllables(7).humanize
    third_line = service.get_syllables(5).humanize

    [first_line, second_line, third_line].join("\n")
  end
end
