require 'test/unit'
require 'main'
require 'interface/input'
require 'interface/prompt'
require 'interface/select'
require 'pp'

class InterfaceTest < Test::Unit::TestCase
  def setup
    @prompt = Interface::Prompt.new(Main::DB)
  end

  def test_select_table
    expected = Interface::Select.new(
      'Select a table: ',
      ['tickets', 'users', 'organizations']
    )

    assert_equal(expected, @prompt.select_table)
  end

  def test_select_field
    expected = Interface::Select.new(
      'Select a field: ',
      ['_id', 'url', 'external_id', 'name', 'domain_names',
       'created_at', 'details', 'shared_tickets', 'tags']
    )

    assert_equal(expected, @prompt.select_field('organizations'))
  end

  def test_select_bool_value
    expected = Interface::Select.new(
      'Select from organizations where shared_tickets is: ',
      [true, false]
    )

    assert_equal(expected, @prompt.input_value('organizations', 'shared_tickets'))
  end

  def test_select_optional_bool_value
    expected = Interface::Select.new(
      'Select from users where verified is: ',
      [nil, true, false]
    )

    assert_equal(expected, @prompt.input_value('users', 'verified'))
  end
end
