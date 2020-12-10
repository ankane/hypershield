require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "active_record"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)
ActiveRecord::Base.logger = logger
ActiveRecord::Migration.verbose = ENV["VERBOSE"]

# migrations
adapter = ENV["ADAPTER"] || "postgresql"
ActiveRecord::Base.establish_connection adapter: adapter, database: "hypershield_test"

ActiveRecord::Base.connection.execute("DROP VIEW IF EXISTS hypershield.users")
ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield")
ActiveRecord::Base.connection.execute("CREATE SCHEMA hypershield")

ActiveRecord::Migration.create_table :users, force: true do |t|
  t.string :name
  t.string :encrypted_email
end

Hypershield.log_sql = true
