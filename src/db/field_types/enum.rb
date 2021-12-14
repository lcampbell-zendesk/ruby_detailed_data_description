module FieldTypes
  def enum(name, values)
    named(name, EnumField.new(values))
  end

  class EnumField
    include UnparsedField

    attr_reader :acceptable_values

    def initialize(acceptable_values)
      @acceptable_values = acceptable_values
    end

    def valid?(value)
      @acceptable_values.include?(value)
    end
  end
end
