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

Given /^the project contains 10 unstarted items in the current and next backlog iteration$/ do
  clear_connections

  project_url = "#{api_url}/projects/#{@project_id}"
  stub_api(project_url, 'project.xml')

  iteration_url = "#{project_url}/iterations/current_backlog?limit=1"
  stub_api(iteration_url, 'current_backlog.xml')

  memberships_url = "#{project_url}/memberships"
  stub_api(memberships_url, 'memberships.xml')
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

Then /^the started item should not be present in the output$/ do
  expect(@output).not_to include('Started Story')
end

Given /^I list the items in the backlog$/ do
  steps %Q{
    Given there is a git repo
    And it contains a pivotal tracker token for a project
    And the project contains 10 unstarted items in the current and next backlog iteration
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
