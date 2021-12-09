require "json"
require "table"

class DataSource
  def initialize(name, fields, path)
    @name = name
    @fields = fields
    @path = path
  end

  def load_into_table
    data = load
    if valid?(data)
      Table.new(@name, @fields, data)
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
end
