# frozen_string_literal: true

require 'http'

module Credence
  # Find or create an SsoAccount based on Github code
  class AuthorizeSso
    def call(access_token)
      github_account = get_github_account(access_token)
      sso_account = find_or_create_sso_account(github_account)

      account_and_token(sso_account)
    end

    def get_github_account(access_token)
      gh_response = HTTP.headers(
        user_agent: 'Credence',
        authorization: "token #{access_token}",
        accept: 'application/json'
      ).get(ENV['GITHUB_ACCOUNT_URL'])

      raise unless gh_response.status == 200

      account = GithubAccount.new(JSON.parse(gh_response))
      { username: account.username, email: account.email }
    end

    def find_or_create_sso_account(account_data)
      Account.first(email: account_data[:email]) ||
        Account.create_github_account(account_data)
    end

    def account_and_token(account)
      {
        type: 'sso_account',
        attributes: {
          account: account,
          auth_token: AuthToken.create(account)
        }
      }
    end
  end
end
