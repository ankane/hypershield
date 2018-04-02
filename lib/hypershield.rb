require "active_support"

require "hypershield/migration"
require "hypershield/engine" if defined?(Rails)
require "hypershield/version"

module Hypershield
  class << self
    attr_accessor :schemas
  end
  self.schemas = {
    hypershield: {
      hide: %w(encrypted password token secret),
      show: []
    }
  }

  class << self
    def drop_view(view)
      schemas.each do |schema, _|
        execute("DROP VIEW IF EXISTS #{quote_ident(schema)}.#{quote_ident(view)}")
      end
    end

    def refresh
      if adapter_name =~ /sqlite/i
        raise "Adapter not supported: #{adapter_name}"
      end

      quiet_logging do
        statements = []

        schemas.each do |schema, config|
          hide = config[:hide].to_a
          show = config[:show].to_a

          tables.sort_by { |k, _| k }.each do |table, columns|
            next if table == "pg_stat_statements"

            statements << "DROP VIEW IF EXISTS #{quote_ident(schema)}.#{quote_ident(table)} CASCADE"

            columns.reject! do |column|
              hide.any? { |m| "#{table}.#{column}".include?(m) } &&
                !show.any? { |m| "#{table}.#{column}".include?(m) }
            end

            if columns.any?
              statements << "CREATE VIEW #{quote_ident(schema)}.#{quote_ident(table)} AS SELECT #{columns.map { |c| quote_ident(c) }.join(", ")} FROM #{quote_ident(table)}"
            end
          end
        end

        if statements.any?
          connection.transaction do
            if mysql?
              statements.each do |statement|
                execute(statement)
              end
            else
              execute(statements.join(";\n"))
            end
          end
        end
      end
    end

    private

    def quiet_logging
      if ActiveRecord::Base.logger
        previous_level = ActiveRecord::Base.logger.level
        begin
          ActiveRecord::Base.logger.level = Logger::INFO
          yield
        ensure
          ActiveRecord::Base.logger.level = previous_level
        end
      else
        yield
      end
    end

    def connection
      ActiveRecord::Base.connection
    end

    def adapter_name
      connection.adapter_name
    end

    def mysql?
      adapter_name =~ /mysql/i
    end

    def tables
      # TODO make schema configurable
      schema =
        if mysql?
          "database()"
        else
          "'public'"
        end

      query = <<-SQL
        SELECT
          table_name,
          column_name,
          ordinal_position,
          data_type
        FROM
          information_schema.columns
        WHERE
          table_schema = #{schema}
      SQL

      Hash[
        select_all(query)
          .group_by { |c| c["table_name"] }
          .map { |t, cs| [t, cs.sort_by { |c| c["ordinal_position"].to_i }.map { |c| c["column_name"] }] }
      ]
    end

    def select_all(sql)
      connection.select_all(sql).to_a
    end

    def execute(sql)
      connection.execute(sql)
    end

    def quote_ident(ident)
      connection.quote_table_name(ident.to_s)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.prepend(Hypershield::Migration)
end
