Feature: List unstarted stories from the current and next iteration in the backlog
  In order to see easily see from the command line what tasks are available to start with
  As a developer
  I want to list unstarted stories from the current and next iteration in the backlog

  Scenario: view unstarted items in the current and next iteration in backlog
    Given there is a git repo
    And it contains a pivotal tracker token for a project
    And the project contains 10 unstarted items in the current and next backlog iteration
    When I navigate to this repo
    And I run the command to list the next items
    Then the output should contain 10 items
    And it should display the task ID, description, type and owner
    And the started item should not be present in the output
