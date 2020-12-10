module Hypershield
  module Migration
    def method_missing(method, *args, **options)
      if [
        :change_column, :drop_table, :remove_column, :remove_columns,
        :remove_timestamps, :rename_column, :rename_table
      ].include?(method)
        Hypershield.drop_view(args[0])
      end

      super
    end
  end
end
