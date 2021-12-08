require 'json'
require 'pp'

class DataSource
  def initialize(name, fields, path)
    @name = name
    @fields = fields
    @path = path
  end

  # Bad name
  def execute
    data = load
    if valid?(data)
      DataSet.new(@name, @fields, data)
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

class DataSet
  def initialize(name, fields, data)
  end
end

module FieldTypes
  def string(name)
    NamedField.new(name, StringField.new)
  end

  def int(name)
    NamedField.new(name, IntField.new)
  end

  def boolean(name)
    NamedField.new(name, BooleanField.new)
  end

  def array_of_strings(name)
    NamedField.new(name, ArrayField.new(StringField.new))
  end

  def uuid(name)
    string(name)
  end

  def url(name)
    string(name)
  end

  def date(name)
    string(name)
  end

  def enum(name, values)
    string(name)
  end

  def email(name)
    string(name)
  end

  def phone(name)
    string(name)
  end

  private

  class AbstractField
    def valid?(value)
      raise "not implemented"
    end

    def parse(value)
      value
    end
  end

  class NamedField
    def initialize(name, type)
      @name = name
      @type = type
    end

    def valid?(row)
      unless @type.valid?(row[@name])
        pp row
        puts @type
        pp @name
        raise "invalid NamedField"
      end

      true
    end

    def parse(row)
      {@name => @type.parse(row[@name])}
    end
  end

  class OptionalField < AbstractField
    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.nil? || @type.valid?(value)
    end
  end

  class StringField < AbstractField
    def valid?(value)
      value.is_a?(String)
    end
  end

  class IntField < AbstractField
    def valid?(value)
      value.is_a?(Integer)
    end
  end

  class BooleanField < AbstractField
    def valid?(value)
      [true, false].include?(value)
    end
  end

  class ArrayField < AbstractField
    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.is_a?(Array) &&
        value.all?{|v| @type.valid?(v) }
    end
  end

end

include FieldTypes

TICKET_FIELDS = [
  uuid( '_id'),
  url('url'),
  uuid('external_id'),
  date('created_at'),
  NamedField.new('type', OptionalField.new(StringField.new)), # enum(['incident'])
  string('subject'),
  NamedField.new('description', OptionalField.new(StringField.new)),
  enum('priority', ['high']),
  enum('status', ['pending']),
  int('submitter_id'),
  NamedField.new('assignee_id', OptionalField.new(IntField.new)), # reference
  NamedField.new('organization_id', OptionalField.new(IntField.new)), # reference
  array_of_strings('tags'),
  boolean('has_incidents'),
  NamedField.new('due_at', OptionalField.new(StringField.new)), # date
  enum('via', ['web'])
]

USER_FIELDS = [
  int('_id'),
  url('url'),
  uuid('external_id'),
  string('name'),
  string('alias'),
  date('created_at'),
  boolean('active'),
  boolean('verified'),
  boolean('shared'),
  enum('locale', ['en-AU']),
  string('timezone'),
  date('last_login_at'),
  email('email'),
  phone('phone'),
  string('signature'),
  int('organization_id'),
  array_of_strings('tags'),
  boolean('suspended'),
  enum('role', ['admin'])
]

ORGANIZATION_FIELDS = [
  int('_id'),
  url('url'),
  uuid('external_id'),
  string('name'),
  array_of_strings('domain_names'),
  date('created_at'),
  string('details'),
  boolean('shared_tickets'),
  array_of_strings('tags')
]

TICKETS = DataSource.new('tickets', TICKET_FIELDS, 'data/tickets.json').execute
USERS = DataSource.new('users', USER_FIELDS, 'data/users.json')
ORGANIZATIONS = DataSource.new('organizations', ORGANIZATION_FIELDS, 'data/organizations.json')
