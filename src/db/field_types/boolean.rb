require 'db/field_types/enum'

module FieldTypes
  def boolean(name)
    named(name, EnumField.new([true, false]))
  end
end
