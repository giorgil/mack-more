module Mack
  module Genosaurus # :nodoc:
    module ActiveRecord # :nodoc:
      module Helpers
      
        def columns(name = param(:name))
          ivar_cache("form_columns") do
            cs = []
            cols = (param(:cols) || param(:columns))
            if cols
              cols.split(",").each do |x|
                cs << Mack::Genosaurus::ActiveRecord::ModelColumn.new(name, x)
              end
            end
            cs
          end
        end

        def db_directory
          File.join(Mack.root, "db")
        end
      
        def migrations_directory
          File.join(db_directory, "migrations")
        end
      
        def next_migration_number
          last = Dir.glob(File.join(migrations_directory, "*.rb")).last
          if last
            return File.basename(last).match(/^\d+/).to_s.succ
          end
          return "001"
        end
      
        ::Genosaurus.send(:include, self)
      
      end # Helpers
    end # ActiveRecord
  end # Genosaurus
end # Mack