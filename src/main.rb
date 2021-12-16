require 'schema'

require 'db/datasource'
require 'db/table'
require 'db/database'

require 'interface/prompt'
require 'interface/output'

module Main
  include Schema

  TICKETS = DataSource.new('tickets', TICKET_FIELDS, 'data/tickets.json').load_into_table
  USERS = DataSource.new('users', USER_FIELDS, 'data/users.json').load_into_table
  ORGANIZATIONS = DataSource.new('organizations', ORGANIZATION_FIELDS, 'data/organizations.json').load_into_table

  DB = Database.new([TICKETS, USERS, ORGANIZATIONS])
  PROMPT = Interface::Prompt.new(DB)

  def self.run
    table = PROMPT.select_table.display
    field = PROMPT.select_field(table).display
    value = PROMPT.input_value(table, field).display

    results = DB.search(table, field, value)

    puts Interface::Output.format_results(results)
  rescue Interrupt
    puts
  end
end
