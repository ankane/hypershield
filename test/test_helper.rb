require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "active_record"

logger = ActiveSupport::Logger.new(STDOUT)

# for debugging
ActiveRecord::Base.logger = logger

# create test database if not exists
adapter = ENV["ADAPTER"] || "postgresql"
database = adapter == "postgresql" ? "postgres" : "mysql"
user = adapter == "mysql2" ? "root" : nil
password = adapter == "mysql2" ? "root" : nil

ActiveRecord::Base.establish_connection adapter: adapter, database: database, username: user, password: password
ActiveRecord::Base.connection.execute "DROP DATABASE IF EXISTS hypershield_test"
ActiveRecord::Base.connection.execute "CREATE DATABASE hypershield_test"

# migrations
ActiveRecord::Base.establish_connection adapter: adapter, database: "hypershield_test", username: user, password: password

ActiveRecord::Base.connection.execute("DROP VIEW IF EXISTS hypershield.users")
ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield")
ActiveRecord::Base.connection.execute("CREATE SCHEMA hypershield")

ActiveRecord::Migration.create_table :users, force: true do |t|
  t.string :name
  t.string :encrypted_email
end

Hypershield.log_sql = true
