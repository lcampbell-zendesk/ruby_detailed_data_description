module FieldTypes
  def string(name)
    named(name, StringField.new)
  end

  class StringField
    include UnparsedField

    def valid?(value)
      value.is_a?(String)
    end
  end
end
