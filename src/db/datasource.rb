require "json"
require "db/table"

class DataSource
  def initialize(name, fields, path)
    @name = name
    @fields = fields
    @path = path
  end

  def load_into_table
    data = load
    if valid?(data)
      Table.new(@name, @fields, parse(data))
    else
      raise "invalid data"
    end
  end

  private

  def load
    JSON.parse(open(@path).read)
  end

  def valid?(data)
    raise "datasource must be an array" unless data.is_a?(Array)

    data.all? do |row|
      @fields.all? do |field|
        field.valid?(row)
      end
    end
  end

  def parse(data)
    data.map do |row|
      @fields.map do |field|
        field.parse(row)
      end.reduce(&:merge)
    end
  end
end
