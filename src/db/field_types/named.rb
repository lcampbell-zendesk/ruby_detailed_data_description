module FieldTypes
  def named(name, type)
    NamedField.new(name, type)
  end

  # TODO: Not so happy about exposing type here
  class NamedField
    attr_reader :name, :type

    def initialize(name, type)
      @name = name
      @type = type
    end

    def valid?(row)
      value = row[@name]

      unless @type.valid?(value)
        raise "invalid NamedField #{@name} : #{value}"
      end

      true
    end

    def parse(row)
      {@name => @type.parse(row[@name])}
    end
  end
end
