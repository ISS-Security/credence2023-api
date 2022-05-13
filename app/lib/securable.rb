# frozen_string_literal: true

require 'base64'
require 'rbnacl'

# Crypto methods for mixin
module Securable
  class NoKeyError < StandardError; end

  # Generate key for Rake tasks (typically not called at runtime)
  def generate_key
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    Base64.strict_encode64 key
  end

  # Call setup once to pass in config variable with DB_KEY attribute
  def setup(base_key)
    raise NoKeyError unless base_key

    @base_key = base_key
  end

  def key
    @key ||= Base64.strict_decode64(@base_key)
  end

  # Encrypt with no checks
  def base_encrypt(plaintext)
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    simple_box.encrypt(plaintext)
  end

  # Decrypt with no checks
  def base_decrypt(ciphertext)
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    simple_box.decrypt(ciphertext).force_encoding('UTF-8')
  end
end
