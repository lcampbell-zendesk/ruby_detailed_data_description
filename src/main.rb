require 'json'
require 'pp'

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

class Table
  def initialize(name, fields, data)
    @name = name
    @fields = fields
    @data = data
  end
end

class Database
  def initialize(tables)
    @tables = tables
  end
end

module FieldTypes
  def named(name, type)
    NamedField.new(name, type)
  end

  def optional(name, type)
    named(name, OptionalField.new(type))
  end

  def id(name, type)
    named(name, IdField.new(type))
  end

  def string(name)
    named(name, StringField.new)
  end

  def int(name)
    named(name, IntField.new)
  end

  def boolean(name)
    named(name, BooleanField.new)
  end

  def array_of_strings(name)
    named(name, ArrayField.new(StringField.new))
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
    named(name, EnumField.new(values))
  end

  def email(name)
    named(name, EmailField.new)
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
        raise "invalid NamedField #{@name} : #{value}"
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

  class UUIDField
    include UnparsedField
    UUIDPattern = /[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/

    def valid?(value)
      UUIDPattern.match?(value)
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

  class EmailField
    include UnparsedField

    def valid?(value)
      URI::MailTo::EMAIL_REGEXP.match?(value)
    end
  end

  class ReferenceField
    def initialize(name, join_table, type)
      @name = name
      @join_table = join_table
      @type = type
    end

    def valid?(value)
      @type.valid?(value)
    end

    def parse(value)
      @type.parse(value)
    end
  end

  class IdField
    def initialize(type)
      @type = type
    end

    def valid?(value)
      @type.valid?(value)
    end

    def parse(value)
      @type.parse(value)
    end
  end

end

include FieldTypes

TICKET_FIELDS = [
  id('_id', UUIDField.new),
  url('url'),
  uuid('external_id'),
  date('created_at'),
  optional('type', EnumField.new(['incident', 'problem', 'task', 'question'])),
  string('subject'),
  optional('description', StringField.new),
  enum('priority', ['high', 'low', 'normal', 'urgent']),
  enum('status', ['pending', 'hold', 'closed', 'solved', 'open']),
  int('submitter_id'),
  optional('assignee_id', ReferenceField.new('assignee', 'users', IntField.new)),
  optional('organization_id', ReferenceField.new('organization', 'organizations', IntField.new)),
  array_of_strings('tags'),
  boolean('has_incidents'),
  optional('due_at', StringField.new), # date
  enum('via', ['web', 'chat', 'voice'])
]

USER_FIELDS = [
  id('_id', IntField.new),
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
  optional('email', EmailField.new),
  phone('phone'),
  string('signature'),
  optional('organization_id', ReferenceField.new('organization', 'organizations', IntField.new)),
  array_of_strings('tags'),
  boolean('suspended'),
  enum('role', ['admin', 'agent', 'end-user'])
]

ORGANIZATION_FIELDS = [
  id('_id', IntField.new),
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

DATABASE = Database.new([TICKETS, USERS, ORGANIZATIONS])
