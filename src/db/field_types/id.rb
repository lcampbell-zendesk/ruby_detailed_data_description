module FieldTypes
  def id(name, type)
    named(name, IdField.new(type))
  end

  class IdField
    def initialize(type)
      @type = type
    end

    def valid?(value)
      @type.valid?(value)
    end

    def parse(value)
      @type.parse(value)
    end
  end
end
