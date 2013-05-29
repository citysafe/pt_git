Given /^there is a git repo$/ do
  create_dir 'test_repo'
  cd 'test_repo'
  run_simple('git init .')
  run_simple('touch README')
  run_simple('git add .')
  run_simple('git commit -m "Initial commit"')
  ENV['DOT_GIT_DIR'] = "tmp/aruba#{ENV['TDDIUM_TID']}/test_repo/.git"
end

Given /^it contains a pivotal tracker token for a project$/ do
  @api_token = @project_id = 123
  run_simple("git config --local pivotal.api-token #{@api_token}")
  run_simple("git config --local pivotal.project-id #{@project_id}")
  run_simple("git config --local pivotal.use-ssl 1")
end

Given /^the project contains 11 items in the backlog$/ do
  clear_connections

  project_url = "#{api_url}/projects/#{@project_id}"
  stub_api(project_url, 'project.xml')

  iteration_url = "#{project_url}/iterations/current_backlog?offset=0&limit=2"
  stub_api(iteration_url, 'current_backlog_0_2.xml')

  iteration_url = "#{project_url}/iterations/current_backlog?offset=3&limit=2"
  stub_api(iteration_url, 'current_backlog_3_2.xml')

  memberships_url = "#{project_url}/memberships"
  stub_api(memberships_url, 'memberships.xml')
end

When /^I navigate to this repo$/ do
end

When /^I run the command to list the next items$/ do
  stub_stdin_stdout do
    PtGit::Pivotal.new(@stdin, @stdout).list_backlog
  end
end

Then /^the output should contain (\d+) unstarted items$/ do |count|
  (1..count.to_i).each do |index|
    expect(@output).to include("Story #{index}")
  end
end

Then /^it should display the task ID, description, type and owner$/ do
  expect(@output).to include('4459994')
  expect(@output).to include('Story 1')
  expect(@output).to include('feature')
  expect(@output).to include('TL')
end

Then /^the (\d+)th item should not be present in the output$/ do |index|
  expect(@output).not_to include("Story #{index}")
end

Then /^started items should not be present in the output$/ do
  expect(@output).not_to include('Started Story')
end

Given /^I list the items in the backlog$/ do
  steps %Q{
    Given there is a git repo
    And it contains a pivotal tracker token for a project
    And the project contains 11 items in the backlog
    And I navigate to this repo
  }
end

When /^I choose the second item$/ do
  @stdin = StringIO.new
  @stdin.puts '2'
  @stdin.rewind
  step "I run the command to list the next items"
end

Then /^I should be on a new git branch$/ do
  expect(PtGit::Project.config.current_branch).not_to eq('master')
end

Then /^the branch name should include the story ID$/ do
  story = PtGit::Project.current.next_unstarted_stories[1]
  expect(PtGit::Project.config.current_branch).to include(story.id.to_s)
end

Given /^I am on a branch that contains the story ID$/ do
  step "there is a git repo"

  @story_id = '28991819'
  run_simple("git checkout -B feature-#{@story_id}")
end

When /^I make a commit$/ do
  PtGit::Project.config.install_git_hooks

  run_simple("touch foo.rb")
  sleep 1
  @repo = PtGit::Project.config.repository
  @repo.add '.'
  @repo.commit_index 'My commit'
end

Then /^I should see the story ID in the commit message$/ do
  commit_message = @repo.commits_since('HEAD').first.message
  expect(commit_message).to include(@story_id)
end

Given /^I am in the project folder$/ do
  steps %Q{
    Given there is a git repo
    And it contains a pivotal tracker token for a project
    And the project contains 11 items in the backlog
  }
end

Given /^there are two stories in the backlog$/ do
  doc            = Nokogiri::XML(read_fixture("stories.xml"))
  @stories_nodes = doc.xpath("//story")[0, 2]
  @stories       = @stories_nodes.map {|node| PivotalTracker::Story.parse(node.to_xml) }

  @stories_nodes.each do |node|
    story_url = "#{api_url}/projects/#{@project_id}/stories/#{node.at_xpath('id').text}"
    stub_request(:get, story_url).to_return(body: node.to_s)

    notes_url = "#{story_url}/notes"
    stub_request(:get, notes_url).to_return(body: node.at_xpath('notes').to_s)
  end
end

Given /^the first story has a description$/ do
  expect(@stories.first.description).to_not be_empty
end

Given /^the second has no description$/ do
  expect(@stories.last.description).to be_empty
end

When /^I show the first story$/ do
  stub_stdin_stdout do
    PtGit::Pivotal.new(@stdin, @stdout).show_story(@stories.first.id)
  end
end

Then /^I should see its description$/ do
  expect(@output).to include(@stories.first.description)
end

When /^I show the second story$/ do
  stub_stdin_stdout do
    PtGit::Pivotal.new(@stdin, @stdout).show_story(@stories.last.id)
  end
end

Then /^I should see that there is no description$/ do
  expect(@output).to include("Description:\n\n")
end

Given /^the first one has no comments$/ do
  expect(@stories_nodes.first.xpath('.//note')).to be_empty
end

Given /^the second has two comments$/ do
  expect(@stories_nodes.last.xpath('.//note').size).to eq(2)
end

Then /^I should see that it has no comments/ do
  expect(@output).to_not include('Comment')
end

Then /^I should see that it has two comments$/ do
  @comments = @stories_nodes.last.xpath('note')
  @comments.each do |comment|
    expect(@output).to include(comment.at_xpath('text').text)
  end
end

Then /^I should see when the comments were made$/ do
  @comments.each do |comment|
    expect(@output).to include(comment.at_xpath('noted_at').text)
  end
end

Then /^I should see who made the comments$/ do
  @comments.each do |comment|
    expect(@output).to include(comment.at_xpath('author').text)
  end
end
