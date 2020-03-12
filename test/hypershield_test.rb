require_relative "test_helper"

class HypershieldTest < Minitest::Test
  def test_works
    Hypershield.refresh(dry_run: true)
    assert Hypershield.refresh
    assert Hypershield.refresh

    result = ActiveRecord::Base.connection.select_all("SELECT * FROM hypershield.users")
    assert_equal ["id", "name"], result.columns
  end
end
