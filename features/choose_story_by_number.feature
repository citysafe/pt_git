@wip
Feature: Choose a story from backlog by number
  In order to start working on a new feature quickly
  As a developer
  I want to choose a story from the backlog by number

  Scenario: Choose a story from backlog by number
    Given I list the items in the backlog
    When I choose the second item
    Then I should be on a new git branch
    And the branch name should include the story ID

