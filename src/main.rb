require 'pp'

require 'schema'

require 'db/datasource'
require 'db/table'
require 'db/database'

require 'interface/select_table'
require 'interface/select_field'
require 'interface/input_value'

module Main
  include Schema

  TICKETS = DataSource.new('tickets', TICKET_FIELDS, 'data/tickets.json').load_into_table
  USERS = DataSource.new('users', USER_FIELDS, 'data/users.json').load_into_table
  ORGANIZATIONS = DataSource.new('organizations', ORGANIZATION_FIELDS, 'data/organizations.json').load_into_table

  DB = Database.new([TICKETS, USERS, ORGANIZATIONS])

  def self.run
    screen = Interface::SelectTable.new(DB)
    table = screen.prompt.display

    screen = Interface::SelectField.new(DB, table)
    field = screen.prompt.display

    screen = Interface::InputValue.new(DB, table, field)
    value = screen.prompt.display

    pp DB.search(table, field, value)
  end
end
