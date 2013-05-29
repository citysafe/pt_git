Feature: List the next 10 unstarted items from the backlog
  In order to see easily see from the command line what tasks are available to start with
  As a developer
  I want to list the next 10 unstarted items from the backlog

  Scenario: view next 10 unstarted items in the backlog
    Given there is a git repo
    And it contains a pivotal tracker token for a project
    And the project contains 11 items in the backlog
    When I navigate to this repo
    And I run the command to list the next items
    Then the output should contain 10 unstarted items
    And it should display the task ID, description, type and owner
    And the 11th item should not be present in the output
    And started items should not be present in the output
