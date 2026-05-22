require_relative "test_helper"

class HypershieldTest < Minitest::Test
  def setup
    super
    reset_schema
  end

  def test_works
    assert_output(/CREATE VIEW/) do
      Hypershield.refresh(dry_run: true)
    end
    assert Hypershield.refresh
    assert Hypershield.refresh

    result = ActiveRecord::Base.connection.select_all("SELECT * FROM hypershield.users")
    assert_equal ["id", "name"], result.columns

    if postgresql?
      error = assert_raises(ActiveRecord::StatementInvalid) do
        ActiveRecord::Base.connection.select_all("SELECT * FROM hypershield.users_matview")
      end
      assert_match "PG::UndefinedTable", error.message
    end
  end

  def test_materialized_views
    Hypershield.materialized_views = true

    assert_output(/CREATE VIEW/) do
      Hypershield.refresh(dry_run: true)
    end
    assert Hypershield.refresh
    assert Hypershield.refresh

    result = ActiveRecord::Base.connection.select_all("SELECT * FROM hypershield.users")
    assert_equal ["id", "name"], result.columns

    if postgresql?
      result = ActiveRecord::Base.connection.select_all("SELECT * FROM hypershield.users_matview")
      assert_equal ["id", "name", "extra"], result.columns
    end
  ensure
    Hypershield.materialized_views = false
  end

  private

  def postgresql?
    $adapter == "postgresql"
  end
end
