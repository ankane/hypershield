module Hypershield
  class Railtie < Rails::Railtie
    rake_tasks do
      namespace :hypershield do
        task refresh: :environment do
          $stderr.puts "[hypershield] Refreshing schemas"
          Hypershield.refresh
          $stderr.puts "[hypershield] Success!"
        end
      end

      Rake::Task["db:migrate"].enhance do
        Rake::Task["hypershield:refresh"].invoke
      end

      Rake::Task["db:rollback"].enhance do
        Rake::Task["hypershield:refresh"].invoke
      end
    end
  end
end
