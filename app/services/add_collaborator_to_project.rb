# frozen_string_literal: true

module Credence
  # Add a collaborator to another owner's existing project
  class AddCollaboratorToProject
    # Error for owner cannot be collaborator
    class OwnerNotCollaboratorError < StandardError
      def message = 'Owner cannot be collaborator of project'
    end

    def self.call(email:, project_id:)
      collaborator = Account.first(email:)
      project = Project.first(id: project_id)
      raise(OwnerNotCollaboratorError) if project.owner.id == collaborator.id

      project.add_collaborator(collaborator)
    end
  end
end
