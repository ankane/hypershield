module Hypershield
  module Migration
    def method_missing(method, *args, **options)
      if [
        :change_column, :change_table, :drop_join_table, :drop_table,
        :remove_belongs_to, :remove_column, :remove_columns,
        :remove_reference, :remove_timestamps, :rename_column, :rename_table
      ].include?(method)
        Hypershield.drop_view(args[0])
      end

      super
    end
  end
end
