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

Given /^the project contains (\d+) items in the backlog$/ do |count|
  PivotalTracker::Client.clear_connections

  api_url = PivotalTracker::Client.api_ssl_url
  fixtures_path = File.join(File.dirname(__FILE__), '../fixtures')

  project_url      = "#{api_url}/projects/#{@project_id}"
  project_response = File.read("#{fixtures_path}/project.xml")
  stub_request(:get, project_url).to_return(body: project_response)

  params = "filter=current_state:unstarted%20story_type:bug,chore,feature&limit=10"
  stories_url      = "#{project_url}/stories?#{params}"
  stories_response = File.read("#{fixtures_path}/stories.xml")
  stub_request(:get, stories_url).to_return(body: stories_response)

  memberships_url = "#{project_url}/memberships"
  memberships_response = File.read("#{fixtures_path}/memberships.xml")
  stub_request(:get, memberships_url).to_return(body: memberships_response)
end

When /^I navigate to this repo$/ do
end

When /^I run the command to list the next items$/ do
  @stdin  ||= StringIO.new
  @stdout ||= StringIO.new
  PtGit::Pivotal.new(@stdin, @stdout).list_backlog
  @output = @stdout.string
end

Then /^the output should contain (\d+) items$/ do |count|
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
  story = PtGit::Project.current.next_ten_stories[1]
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
