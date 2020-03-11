require_relative "test_helper"

class HypershieldTest < Minitest::Test
  def test_works
    Hypershield.refresh(dry_run: true)
    assert Hypershield.refresh
    assert Hypershield.refresh
  end
end
