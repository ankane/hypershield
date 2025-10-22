require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "active_record"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)
ActiveRecord::Base.logger = logger
ActiveRecord::Migration.verbose = ENV["VERBOSE"]

# migrations
adapter = ENV["ADAPTER"] || "postgresql"
options = {}
options[:host] = "127.0.0.1" if adapter == "trilogy"
ActiveRecord::Base.establish_connection adapter: adapter, database: "hypershield_test", **options

if adapter == "postgresql"
  ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield CASCADE")
else
  ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield")
end
ActiveRecord::Base.connection.execute("CREATE SCHEMA hypershield")

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.string :encrypted_email
  end
end

Hypershield.log_sql = true
