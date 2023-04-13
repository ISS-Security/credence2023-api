# frozen_string_literal: true

require 'json'
require 'sequel'

module Credence
  # Models a project
  class Project < Sequel::Model
    one_to_many :documents
    plugin :association_dependencies, documents: :destroy

    plugin :timestamps

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'project',
            attributes: {
              id:,
              name:,
              repo_url:
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
