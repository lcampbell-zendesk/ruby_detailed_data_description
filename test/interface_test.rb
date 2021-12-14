require 'test/unit'
require 'main'
require 'interface'

class InterfaceTest < Test::Unit::TestCase
  def setup
  end

  def test_select_table
    expected = Interface::Select.new(
      'Select a table: ',
      ['tickets', 'users', 'organizations']
    )

    screen = Interface::SelectTable.new(Main::DATABASE)
    assert_equal(expected, screen.prompt())
  end

  def test_select_field
    expected = Interface::Select.new(
      'Select a field: ',
      ['_id', 'url', 'external_id', 'name', 'domain_names',
       'created_at', 'details', 'shared_tickets', 'tags']
    )

    screen = Interface::SelectField.new(Main::DATABASE, 'organizations')
    assert_equal(expected, screen.prompt())
  end

  def test_select_bool_value
    expected = Interface::Select.new(
      'Select from organizations where shared_tickets is: ',
      [true, false]
    )

    screen = Interface::InputValue.new(Main::DATABASE, 'organizations', 'shared_tickets')
    assert_equal(expected, screen.prompt())
  end

  def test_select_optional_bool_value
    expected = Interface::Select.new(
      'Select from users where verified is: ',
      [nil, true, false]
    )

    screen = Interface::InputValue.new(Main::DATABASE, 'users', 'verified')
    assert_equal(expected, screen.prompt())
  end
end
