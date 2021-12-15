require 'json'

module Interface
  class Select
    def initialize(prompt, options)
      @prompt = prompt
      @options = options
    end

    def display
      puts @prompt
      puts options_string

      until @options.include?(input = gets.strip)
        puts 'That option is not available.'
        puts options_string
      end

      input
    end

    def options_string
      "One of: #{@options.join(', ')}"
    end
  end

  # TODO: Ideally we wouldn't parse twice
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
  end
end
