module FieldTypes
  def optional(name, type)
    named(name, OptionalField.new(type))
  end

  # TODO: Don't love exposing type here
  class OptionalField
    include UnparsedField

    attr_reader :type

    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.nil? || @type.valid?(value)
    end
  end
end
