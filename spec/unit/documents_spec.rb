# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Document Handling' do
  before do
    wipe_database

    DATA[:projects].each do |project_data|
      Credence::Project.create(project_data)
    end
  end

  it 'HAPPY: should retrieve correct data from database' do
    doc_data = DATA[:documents][1]
    proj = Credence::Project.first
    new_doc = proj.add_document(doc_data)

    doc = Credence::Document.find(id: new_doc.id)
    _(doc.filename).must_equal doc_data['filename']
    _(doc.relative_path).must_equal doc_data['relative_path']
    _(doc.description).must_equal doc_data['description']
    _(doc.content).must_equal doc_data['content']
  end

  it 'SECURITY: should not use deterministic integers' do
    doc_data = DATA[:documents][1]
    proj = Credence::Project.first
    new_doc = proj.add_document(doc_data)

    _(new_doc.id.is_a?(Numeric)).must_equal false
  end

  it 'SECURITY: should secure sensitive attributes' do
    doc_data = DATA[:documents][1]
    proj = Credence::Project.first
    new_doc = proj.add_document(doc_data)
    stored_doc = app.DB[:documents].first

    _(stored_doc[:description_secure]).wont_equal new_doc.description
    _(stored_doc[:content_secure]).wont_equal new_doc.content
  end
end
