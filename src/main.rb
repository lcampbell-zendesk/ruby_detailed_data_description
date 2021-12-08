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
  def optional(name, type)
    NamedField.new(name, OptionalField.new(type))
  end

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
    NamedField.new(name, EnumField.new(values))
  end

  def email(name)
    string(name)
  end

  def phone(name)
    string(name)
  end

  private

  module UnparsedField
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
      value = row[@name]
      unless @type.valid?(value)
        # pp row
        # puts @type
        # pp @name
        # raise "invalid NamedField"
        puts "#{@name} : #{value}"
      end

      true
    end

    def parse(row)
      {@name => @type.parse(row[@name])}
    end
  end

  class OptionalField
    include UnparsedField

    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.nil? || @type.valid?(value)
    end
  end

  class StringField
    include UnparsedField

    def valid?(value)
      value.is_a?(String)
    end
  end

  class IntField
    include UnparsedField

    def valid?(value)
      value.is_a?(Integer)
    end
  end

  class BooleanField
    include UnparsedField

    def valid?(value)
      [true, false].include?(value)
    end
  end

  class ArrayField
    include UnparsedField

    def initialize(type)
      @type = type
    end

    def valid?(value)
      value.is_a?(Array) &&
        value.all?{|v| @type.valid?(v) }
    end
  end

  class EnumField
    include UnparsedField

    def initialize(acceptable_values)
      @acceptable_values = acceptable_values
    end

    def valid?(value)
      @acceptable_values.include?(value)
    end

  end

end

include FieldTypes

TICKET_FIELDS = [
  uuid( '_id'),
  url('url'),
  uuid('external_id'),
  date('created_at'),
  optional('type', EnumField.new(['incident', 'problem', 'task', 'question'])),
  string('subject'),
  optional('description', StringField.new),
  enum('priority', ['high', 'low', 'normal', 'urgent']),
  enum('status', ['pending', 'hold', 'closed', 'solved', 'open']),
  int('submitter_id'),
  optional('assignee_id', IntField.new), # reference
  optional('organization_id', IntField.new), # reference
  array_of_strings('tags'),
  boolean('has_incidents'),
  optional('due_at', StringField.new), # date
  enum('via', ['web', 'chat', 'voice'])
]

USER_FIELDS = [
  int('_id'),
  url('url'),
  uuid('external_id'),
  string('name'),
  optional('alias', StringField.new),
  date('created_at'),
  boolean('active'),
  optional('verified', BooleanField.new),
  boolean('shared'),
  optional('locale', EnumField.new(['en-AU', 'zh-CN', 'de-CH'])),
  optional('timezone', StringField.new),
  date('last_login_at'),
  optional('email', StringField.new), # email
  phone('phone'),
  string('signature'),
  optional('organization_id', IntField.new), # reference
  array_of_strings('tags'),
  boolean('suspended'),
  enum('role', ['admin', 'agent', 'end-user'])
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
USERS = DataSource.new('users', USER_FIELDS, 'data/users.json').execute
ORGANIZATIONS = DataSource.new('organizations', ORGANIZATION_FIELDS, 'data/organizations.json').execute
