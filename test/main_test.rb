require 'test/unit'
require 'main'

class MainTest < Test::Unit::TestCase
  def setup
  end

  def test_ticket_priority_search
    results = Main::DATABASE.search('tickets', 'priority', 'high')
    assert_equal(64, results.length)
  end
end
