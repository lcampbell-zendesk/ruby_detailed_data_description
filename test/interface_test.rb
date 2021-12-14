require 'test/unit'
require 'main'
require 'interface'

class InterfaceTest < Test::Unit::TestCase
  def setup
  end

  def test_select_table
    expected = {
      prompt: 'Select a table: ',
      options: ['tickets', 'users', 'organizations']
    }

    screen = Interface::SelectTable.new(Main::DATABASE)
    assert_equal(expected, screen.prompt())
  end

  def test_select_field
    expected = {
      prompt: 'Select a field: ',
      options: ['_id', 'url', 'external_id', 'name', 'domain_names',
                'created_at', 'details', 'shared_tickets', 'tags']
    }

    screen = Interface::SelectField.new(Main::DATABASE, 'organizations')
    assert_equal(expected, screen.prompt())
  end
end
