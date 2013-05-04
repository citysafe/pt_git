require 'spec_helper'

describe TestBed::Configuration do
  subject(:configuration) { TestBed::Configuration.new }

  describe '#repository' do
    its(:repository) { should be_a_kind_of(Grit::Repo) }
  end

  describe '#git_root' do
    let(:expected) { File.expand_path('../../.git', __FILE__) }

    it 'returns the current git repository path' do
      expect(configuration.send(:git_root)).to eq(expected)
    end
  end

  context 'Given configurations from git repository' do
    before { stub_git_config }

    its(:api_token) { should == '8a8a8a8' }
    its(:project_id) { should == '123' }
    its(:use_ssl?) { should be_true }
    its(:full_name) { should == 'Tien Le' }
    its(:valid?) { should be_true }
  end
end
