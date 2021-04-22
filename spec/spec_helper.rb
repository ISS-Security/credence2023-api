# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  app.DB[:documents].delete
  app.DB[:projects].delete
  app.DB[:accounts].delete
end

DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seed.yml')),
  documents: YAML.load(File.read('app/db/seeds/documents_seed.yml')),
  projects: YAML.load(File.read('app/db/seeds/projects_seed.yml'))
}.freeze
