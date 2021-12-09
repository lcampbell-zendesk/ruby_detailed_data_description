require "schema"
require "datasource"
require "table"
require "database"

module Main
  include Schema

  TICKETS = DataSource.new('tickets', TICKET_FIELDS, 'data/tickets.json').load_into_table
  USERS = DataSource.new('users', USER_FIELDS, 'data/users.json').load_into_table
  ORGANIZATIONS = DataSource.new('organizations', ORGANIZATION_FIELDS, 'data/organizations.json').load_into_table

  DATABASE = Database.new([TICKETS, USERS, ORGANIZATIONS])
end
