require_relative "test_helper"

class HypershieldTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Hypershield::VERSION
  end
end
