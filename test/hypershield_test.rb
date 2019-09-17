require_relative "test_helper"

class HypershieldTest < Minitest::Test
  def test_works
    assert Hypershield.refresh
  end
end
