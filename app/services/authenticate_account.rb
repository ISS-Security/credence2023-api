# frozen_string_literal: true

module Credence
  # Find account and check password
  class AuthenticateAccount
    # Error for invalid credentials
    class UnauthorizedError < StandardError
      def initialize(msg = nil)
        super
        @credentials = msg
      end

      def message
        "Invalid Credentials for: #{@credentials[:username]}"
      end
    end

    def self.call(credentials)
      account = Account.first(username: credentials[:username])
      raise unless account.password?(credentials[:password])

      account_and_token(account)
    rescue StandardError
      raise(UnauthorizedError, credentials)
    end

    def self.account_and_token(account)
      {
        type: 'authenticated_account',
        attributes: {
          account:,
          auth_token: AuthToken.create(account)
        }
      }
    end
  end
end
