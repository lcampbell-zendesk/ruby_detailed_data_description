module FieldTypes
  def array_of_strings(name)
    named(name, ArrayField.new(StringField.new))
  end

  class ArrayField
    include UnparsedField

    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.is_a?(Array) &&
        value.all?{|v| @type.valid?(v) }
    end
  end
end
