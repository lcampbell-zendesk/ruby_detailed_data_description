require 'interface/widgets'

module Interface
  class SelectField
    def initialize(db, table)
      @db = db
      @table = table
    end

    def prompt
      Select.new('Select a field: ', @db.table(@table).field_names)
    end
  end
end
