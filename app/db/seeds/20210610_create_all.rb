# frozen_string_literal: true

require './app/controllers/helpers.rb'
include Credence::SecureRequestHelpers

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, projects, documents'
    create_accounts
    create_owned_projects
    create_documents
    add_collaborators
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
OWNER_INFO = YAML.load_file("#{DIR}/owners_projects.yml")
PROJ_INFO = YAML.load_file("#{DIR}/projects_seed.yml")
DOCUMENT_INFO = YAML.load_file("#{DIR}/documents_seed.yml")
CONTRIB_INFO = YAML.load_file("#{DIR}/projects_collaborators.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    Credence::Account.create(account_info)
  end
end

def create_owned_projects
  OWNER_INFO.each do |owner|
    account = Credence::Account.first(username: owner['username'])
    owner['proj_name'].each do |proj_name|
      proj_data = PROJ_INFO.find { |proj| proj['name'] == proj_name }
      account.add_owned_project(proj_data)
    end
  end
end

def create_documents
  doc_info_each = DOCUMENT_INFO.each
  projects_cycle = Credence::Project.all.cycle
  loop do
    doc_info = doc_info_each.next
    project = projects_cycle.next

    auth_token = AuthToken.create(project.owner)
    auth = scoped_auth(auth_token)

    Credence::CreateDocument.call(
      auth: auth, project: project, document_data: doc_info
    )
  end
end

def add_collaborators
  contrib_info = CONTRIB_INFO
  contrib_info.each do |contrib|
    project = Credence::Project.first(name: contrib['proj_name'])

    auth_token = AuthToken.create(project.owner)
    auth = scoped_auth(auth_token)

    contrib['collaborator_email'].each do |email|
      Credence::AddCollaborator.call(
        auth: auth, project: project, collab_email: email
      )
    end
  end
end
