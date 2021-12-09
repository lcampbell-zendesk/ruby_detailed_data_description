module FieldTypes
  class ReferenceField
    def initialize(name, join_table, type)
      @name = name
      @join_table = join_table
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
