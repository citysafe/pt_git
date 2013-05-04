Given(/^there is a git repo$/) do
  create_dir 'test_repo'
  cd 'test_repo'
  run_simple('git init .')
end

Given(/^it contains a pivotal tracker token for a project$/) do
  @api_token = @project_id = 123
  run_simple("git config --local pivotal.api-token #{@api_token}")
  run_simple("git config --local pivotal.project-id #{@project_id}")
  run_simple("git config --local pivotal.use-ssl 1")
end

Given(/^the project contains (\d+) items in the backlog$/) do |count|
  PivotalTracker::Client.clear_connections

  api_url = PivotalTracker::Client.api_ssl_url
  fixtures_path = File.join(File.dirname(__FILE__), '../fixtures')

  stub_request(:get, "#{api_url}/projects/#{@project_id}")
              .to_return(body: File.read("#{fixtures_path}/project.xml"))

  params = "filter=current_state:unstarted%20story_type:bug,chore,feature&limit=10"
  stub_request(:get, "#{api_url}/projects/#{@project_id}/stories?#{params}")
              .to_return(body: File.read("#{fixtures_path}/stories.xml"))
end

When(/^I navigate to this repo$/) do
end

When(/^I run the command to list the next items$/) do
  run_simple('pt ls')
end

Then(/^the output should contain (\d+) items$/) do |count|
  # TODO: Need to figure out why the `puts` output is not in all_output

  (1..count.to_i).each do |index|
    assert_partial_output("Story #{index}", all_output)
  end
end

Then(/^it should display the task ID, description and type$/) do
  assert_partial_output("4459994", all_output)
  assert_partial_output("Story 1", all_output)
  assert_partial_output("feature", all_output)
end

Then(/^the (\d+)th item should not be present in the output$/) do |index|
  unescape(all_output).should_not =~ /Story #{index}/
end
