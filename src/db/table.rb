class Table
  attr_reader :name

  def initialize(name, fields, data)
    @name = name
    @fields = fields
    @data = data
  end

  def search(field, value)
    @data.select do |row|
      row[field] == value
    end
  end

  def field_names
    @fields.map(&:name)
  end

  def field(name)
    @fields.find { |f| f.name == name }
  end
end
