require_relative "test_helper"

class ManyTablesTest < Minitest::Test
  TABLES = (0..Hypershield::LARGE_NUMBER_OF_VIEWS+1)

  def setup
    TABLES.each do |table|
      ActiveRecord::Migration.create_table "users_#{table}".to_sym, force: true do |t|
        t.string :name
        t.string :encrypted_email
      end
    end
  end

  def test_it_works
    assert Hypershield.refresh
  end

  def teardown
    TABLES.each do |table|
      ActiveRecord::Base.connection.execute "DROP VIEW IF EXISTS hypershield.users_#{table}"
      ActiveRecord::Migration.drop_table "users_#{table}".to_sym, force: true
    end
  end
end