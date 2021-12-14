require "date"

module FieldTypes
  def date(name)
    named(name, DateField.new)
  end

  class DateField
    def valid?(value)
      parse(value)
      true
    rescue ArgumentError
      false
    end

    def parse(value)
      Date.parse(value)
    end
  end
end
