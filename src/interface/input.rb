require 'json'

# TODO: Ideally we wouldn't parse twice
module Interface
  class Input
    def initialize(prompt, field)
      @prompt = prompt
      @field = field
    end

    def display
      puts @prompt

      until valid_json_and_field?(input = gets.strip)
        puts 'Sorry that is not a valid value for this field.'
      end

      @field.parse(JSON.parse(input))
    end

    private

    def valid_json_and_field?(input)
      @field.valid?(JSON.parse(input))
    rescue JSON::ParserError
      false
    end

    def ==(other)
      self.prompt  == other.prompt &&
        self.field == other.field
    end
  end
end
