module FieldTypes
  def email(name)
    named(name, EmailField.new)
  end

  class EmailField
    include UnparsedField

    def valid?(value)
      URI::MailTo::EMAIL_REGEXP.match?(value)
    end
  end
end
