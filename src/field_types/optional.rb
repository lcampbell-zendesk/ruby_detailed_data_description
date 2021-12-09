module FieldTypes
  def optional(name, type)
    named(name, OptionalField.new(type))
  end

  class OptionalField
    include UnparsedField

    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.nil? || @type.valid?(value)
    end
  end
end
