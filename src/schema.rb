require "db/field_types/all"
require "db/field_types/id"

module Schema
  include FieldTypes
  extend FieldTypes

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
    optional('due_at', DateField.new), # date
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
end
