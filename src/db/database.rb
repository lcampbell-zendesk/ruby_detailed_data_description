class Database
  def initialize(tables)
    @tables = keyed_by_name(tables)
  end

  def search(table, field, value)
    @tables[table].search(field, value)
  end

  def table_names
    @tables.keys
  end

  def table(name)
    @tables[name]
  end

  private

  def keyed_by_name(tables)
    tables.reduce({}) do |accumulator, table|
      accumulator[table.name] = table
      accumulator
    end
  end
end
