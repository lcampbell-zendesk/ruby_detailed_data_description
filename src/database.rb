class Database
  def initialize(tables)
    @tables = tables.reduce({}) do |accumulator, table|
      accumulator[table.name] = table
      accumulator
    end
  end

  def search(table, field, value)
    @tables[table].search(field, value)
  end
end
