# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'sequel'
require_app('lib')

module Credence
  # Configuration for the API
  class Api < Roda
    plugin :environments

    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # load config secrets into local environment variables (ENV)
      Figaro.application = Figaro::Application.new(
        environment: environment, # rubocop:disable Style/HashSyntax
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config = Figaro.env

      # Database Setup
      db_url = ENV.delete('DATABASE_URL')
      DB = Sequel.connect("#{db_url}?encoding=utf8")
      def self.DB = DB # rubocop:disable Naming/MethodName

      # HTTP Request logging
      configure :development, :production do
        plugin :common_logger, $stdout
      end

      # Custom events logging
      LOGGER = Logger.new($stderr)
      def self.logger = LOGGER

      # Load crypto keys
      SecureDB.setup(ENV.delete('DB_KEY')) # Load crypto key
      AuthToken.setup(ENV.fetch('MSG_KEY')) # Load crypto key
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock

    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
    end
  end
end
