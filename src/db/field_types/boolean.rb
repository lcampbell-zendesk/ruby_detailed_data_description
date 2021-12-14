module FieldTypes
  def boolean(name)
    named(name, BooleanField.new)
  end

  class BooleanField
    include UnparsedField

    def valid?(value)
      [true, false].include?(value)
    end
  end
end
