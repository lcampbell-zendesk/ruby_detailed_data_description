require 'interface/widgets'
require 'db/field_types/enum'
require 'db/field_types/optional'

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
        # TODO: I don't love that this is assuming field is named
        Input.new(prompt, field.type)
      end
    end
  end
end
