# frozen_string_literal: true

source 'https://rubygems.org'

# Web API
gem 'json'
gem 'puma', '~>5.6'
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

# Performance
gem 'rubocop-performance'

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
end

# Development
group :development do
  gem 'pry'
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'rack-test'
  gem 'sequel-seed'
  gem 'sqlite3', '~>1.6'
end

# Quality
gem 'rubocop'
