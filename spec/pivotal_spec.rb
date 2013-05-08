require 'spec_helper'

describe TestBed::Pivotal do

  describe 'List the all the next 10 stories from backlog' do
    let(:project) { build(:project) }
    let(:stories) { build_list(:story, 10) }
    let(:output) do
      capture(:stdout) { subject.list_backlog }
    end

    before do
      subject.stub(:project).and_return(project)
      project.stub(:next_ten_stories).and_return(stories)
    end

    it 'shows story type, id, and name' do
      expect(output).to include(stories.first.story_type)
      expect(output).to include(stories.first.id.to_s)
      expect(output).to include(stories.first.name)
    end

    it 'shows upto 10 stories' do
      expect(output.lines.to_a.length).to eq(10)
    end
  end

end

