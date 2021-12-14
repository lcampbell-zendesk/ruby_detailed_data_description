require 'db/field_types/enum'

module Interface
  Select = Struct.new(:prompt, :options)
  Input = Struct.new(:prompt)
end

module Interface
  class SelectTable
    def initialize(db)
      @db = db
    end

    def prompt
      Select.new("Select a table: ", @db.table_names)
    end
  end
end

module Interface
  class SelectField
    def initialize(db, table)
      @db = db
      @table = table
    end

    def prompt
      Select.new("Select a field: ", @db.table(@table).field_names)
    end
  end
end

module Interface
  class InputValue
    def initialize(db, table, field)
      @db = db
      @table = table
      @field = field
    end

    # TODO: This should maybe live in the field classes
    def prompt
      field = @db.table(@table).field(@field)
      prompt = "Select from #{@table} where #{field.name} is: "

      if field.type.is_a?(FieldTypes::EnumField)
        Select.new(prompt, field.type.acceptable_values)
      elsif field.type.is_a?(FieldTypes::OptionalField) &&
            field.type.type.is_a?(FieldTypes::EnumField)
        Select.new(prompt, [nil] + field.type.type.acceptable_values)
      else
        Input.new(prompt)
      end
    end
  end
end

module Interface
  class DisplayResults
    def initialize(db, table, field, value)
      @db = db
      @table = table
      @field = field
      @value = value
    end
  end
end
