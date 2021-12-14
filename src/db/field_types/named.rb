module FieldTypes
  def named(name, type)
    NamedField.new(name, type)
  end

  class NamedField
    attr_reader :name

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
