# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web API
gem 'json'
gem 'puma', '~>6.2'
gem 'roda', '~>3.54'

# Configuration
gem 'figaro', '~>1.2'
gem 'rake', '~>13.0'

# Security
gem 'bundler-audit'
gem 'rbnacl', '~>7.1'

# Database
gem 'hirb', '~>0.7'
gem 'sequel', '~>5.67'

group :production do
  gem 'pg'
end

# External Services
gem 'http'

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
end

# Debugging
gem 'pry' # necessary for rake console
gem 'rack-test'

# Development
group :development do
  gem 'rerun'

  # Quality
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'sequel-seed'
  gem 'sqlite3', '~>1.6'
end
