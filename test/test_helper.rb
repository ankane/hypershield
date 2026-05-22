require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "active_record"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)
ActiveRecord::Base.logger = logger
ActiveRecord::Migration.verbose = ENV["VERBOSE"]

# migrations
$adapter = ENV["ADAPTER"] || "postgresql"
options = {}
options[:host] = "127.0.0.1" if $adapter == "trilogy"
ActiveRecord::Base.establish_connection adapter: $adapter, database: "hypershield_test", **options

def reset_schema
  if $adapter == "postgresql"
    ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield CASCADE")
  else
    ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS hypershield")
  end
  ActiveRecord::Base.connection.execute("CREATE SCHEMA hypershield")
end

ActiveRecord::Schema.define do
  create_table :users, force: :cascade do |t|
    t.string :name
    t.string :encrypted_email
  end

  if $adapter == "postgresql"
    execute "CREATE MATERIALIZED VIEW users_matview AS SELECT *, id AS extra FROM users"
  end
end

Hypershield.log_sql = true
