require 'spec_helper'

describe PtGit::GitConfig do

  let(:mock_git_repo) { mock('Grit::Repo', config: git_config) }
  let(:api_token) { 'token' }
  let(:project_id) { 123 }
  let(:git_config) do
    {
      'pivotal.api-token' => api_token,
      'pivotal.project-id' =>  project_id,
      'pivotal.use-ssl' => '1'
    }
  end

  context 'Get all configurations from the current git repo config' do
    before do
      Grit::Repo.stub(:new).and_return mock_git_repo
    end

    its(:api_token)  { should == api_token }
    its(:project_id) { should == project_id }
    its(:use_ssl?)   { should be_true }
  end

  describe 'Determine the git repo in working path when running' do
    let(:expected) { File.expand_path('../../.git', __FILE__) }

    it 'returns the nearest .git folder' do
      expect(subject.send(:git_root)).to eq(expected)
    end
  end

end

