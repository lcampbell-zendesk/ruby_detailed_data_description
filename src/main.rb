require 'json'
require 'pp'

class Dataset
  def initialize(name, path, fields)
    @name = name
    @path = path
    @fields = fields
  end

  def load
    JSON.parse(open(@path).read)
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

  class NamedField
    def initialize(name, type)
      @name = name
      @type = type
    end
  end

  class AbstractField
    def validate
      raise :not_implemented
    end

    def parse(value)
      value
    end
  end

  class StringField < AbstractField
    def validate(value)
      value.is_a?(String)
    end
  end

  class IntField < AbstractField
    def validate(value)
      value.is_a?(Integer)
    end
  end

  class BooleanField < AbstractField
    def validate(value)
      [true, false].include?(value)
    end
  end

  class ArrayField < AbstractField
    def initialize(type)
      @type = type
    end

    def validate(value)
      value.is_a?(Array) &&
        value.all?{|v| @type.validate(v) }
    end
  end

end

include FieldTypes

TICKET_FIELDS = [
  uuid( '_id'),
  url('url'),
  uuid('external_id'),
  date('created_at'),
  enum('type', ['incident']),
  string('subject'),
  string('description'),
  enum('priority', ['high']),
  enum('status', ['pending']),
  int('submitter_id'),
  int('assignee_id'),
  int('organization_id'),
  array_of_strings('tags'),
  boolean('has_incidents'),
  date('due_at'),
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

TICKETS = Dataset.new('tickets', 'data/tickets.json', TICKET_FIELDS)
USERS = Dataset.new('users', 'data/users.json', USER_FIELDS)
ORGANIZATIONS = Dataset.new('organizations', 'data/organizations.json', ORGANIZATION_FIELDS)
