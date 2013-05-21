require 'spec_helper'

describe PtGit::Project do
  let(:current_project_id) { 123 }
  let(:api_token) { 'token' }
  let(:mock_config) { mock('GitConfig', api_token: api_token, project_id: current_project_id, use_ssl?: true) }
  let(:story) { build(:story) }
  subject(:project) { build(:project) }

  before do
    PtGit::Project.stub(:config).and_return(mock_config)
  end

  describe 'Get the current Pivotal Tracker project' do
    it 'initializes the connection to Pivotal Tracker API' do
      PtGit::Project.should_receive(:init_connection)
      PtGit::Project.stub(:find)
      PtGit::Project.current
    end

    it 'finds the project by current id' do
      PtGit::Project.should_receive(:find).with(current_project_id)
      PtGit::Project.current
    end
  end

  describe "Get Pivotal Tracker initials from the story's owner" do
    before do
      project.should_receive(:find_membership_by_name).and_return(membership)
    end

    context 'When the story has been owned by someone' do
      let(:membership) { build(:membership, name: story.name) }

      it 'returns the short name (initials) of that owner' do
        expect(project.owner_initials_for(story)).to eq(membership.initials)
      end
    end

    context 'When the story has not been owned by anyone' do
      let(:membership) { nil }

      it 'does not return any initials' do
        expect(project.owner_initials_for(story)).to be_nil
      end
    end
  end
end

