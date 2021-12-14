module Interface
  class SelectTable
    def initialize(db)
      @db = db
    end

    def prompt
      {
        prompt: "Select a table: ",
        options: @db.table_names
      }
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
      {
        prompt: "Select a field: ",
        options: @db.table(@table).field_names
      }
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

    def prompt
      @db.table(@table).field(@field).prompt
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
