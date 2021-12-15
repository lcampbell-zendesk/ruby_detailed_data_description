require 'interface/widgets'

module Interface
  class SelectTable
    def initialize(db)
      @db = db
    end

    def prompt
      Select.new('Select a table: ', @db.table_names)
    end
  end
end
