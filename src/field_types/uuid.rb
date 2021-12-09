module FieldTypes
  def uuid(name)
    named(name, UUIDField.new)
  end

  class UUIDField
    include UnparsedField
    UUIDPattern = /[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/

    def valid?(value)
      UUIDPattern.match?(value)
    end
  end
end
