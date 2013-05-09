require 'spec_helper'

describe TestBed::Project do
  let(:current_project_id) { 123 }
  let(:api_token) { 'token' }
  let(:mock_config) { mock('GitConfig', api_token: api_token, project_id: current_project_id, use_ssl?: true) }

  before do
    TestBed::Project.stub(:config).and_return(mock_config)
  end

  describe 'Get the current Pivotal Tracker project' do
    it 'initializes the connection to Pivotal Tracker API' do
      TestBed::Project.should_receive(:init_connection)
      TestBed::Project.stub(:find)
      TestBed::Project.current
    end

    it 'finds the project by current id' do
      TestBed::Project.should_receive(:find).with(current_project_id)
      TestBed::Project.current
    end
  end

end

