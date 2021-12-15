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
