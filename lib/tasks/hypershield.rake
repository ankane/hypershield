namespace :hypershield do
  task refresh: :environment do
    $stderr.puts "[hypershield] Refreshing schemas"
    Hypershield.refresh
    $stderr.puts "[hypershield] Success!"
  end

  namespace :refresh do
    task dry_run: :environment do
      Hypershield.refresh(dry_run: true)
    end
  end
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["hypershield:refresh"].invoke
end

Rake::Task["db:rollback"].enhance do
  Rake::Task["hypershield:refresh"].invoke
end
