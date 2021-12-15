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
end
