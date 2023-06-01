# frozen_string_literal: true

# rubocop:disable Style/HashSyntax, Style/SymbolArray, Metrics/BlockLength
require 'rake/testtask'
require './require_app'

task :default => :spec

desc 'Tests API specs only'
task :api_spec do
  sh 'ruby spec/api_spec.rb'
end

desc 'Test all the specs'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.warning = false
end

desc 'Rerun tests on live code changes'
task :respec do
  sh 'rerun -c rake spec'
end

desc 'Runs rubocop on tested code'
task :style => [:spec, :audit] do
  sh 'rubocop .'
end

desc 'Update vulnerabilities lit and audit gems'
task :audit do
  sh 'bundle audit check --update'
end

desc 'Checks for release'
task :release? => [:spec, :style, :audit] do
  puts "\nReady for release!"
end

task :print_env do
  puts "Environment: #{ENV.fetch('RACK_ENV', nil) || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
  sh 'pry -r ./spec/test_load_all'
end

namespace :db do
  task :load do
    require_app(nil) # loads config code files only
    require 'sequel'

    Sequel.extension :migration
    @app = Credence::Api
  end

  task :load_models => :load do
    require_app(%w[lib models policies services])
  end

  desc 'Run migrations'
  task :migrate => [:load, :print_env] do
    puts 'Migrating database to latest'
    Sequel::Migrator.run(@app.DB, 'app/db/migrations')
  end

  desc 'Destroy data in database; maintain tables'
  task :delete => :load do
    Credence::Account.dataset.destroy
  end

  desc 'Delete dev or test database file'
  task :drop => :load do
    if @app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    db_filename = "app/db/store/#{Credence::Api.environment}.db"
    FileUtils.rm(db_filename)
    puts "Deleted #{db_filename}"
  end

  task :reset_seeds => :load_models do
    @app.DB[:schema_seeds].delete if @app.DB.tables.include?(:schema_seeds)
    Credence::Account.dataset.destroy
  end

  desc 'Seeds the development database'
  task :seed => :load_models do
    require_app(%w[lib models policies services])
    require 'sequel/extensions/seed'
    Sequel::Seed.setup(:development)
    Sequel.extension :seed
    Sequel::Seeder.apply(@app.DB, 'app/db/seeds')
  end

  desc 'Delete all data and reseed'
  task reseed: [:reset_seeds, :seed]
end

namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require_app('lib')
    puts "DB_KEY: #{SecureDB.generate_key}"
  end

  desc 'Create sample cryptographic key for tokens and messaging'
  task :msg do
    require_app('lib')
    puts "MSG_KEY: #{AuthToken.generate_key}"
  end
end

namespace :run do
  # Run in development mode
  desc 'Run API in development mode'
  task :dev do
    sh 'puma -p 3000'
  end
end
# rubocop:enable Style/HashSyntax, Style/SymbolArray, Metrics/BlockLength
