module FieldTypes
  def int(name)
    named(name, IntField.new)
  end

  class IntField
    include UnparsedField

    def valid?(value)
      value.is_a?(Integer)
    end
  end
end
