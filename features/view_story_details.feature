Feature: View details of a story
  In order to understand more about a story before starting
  And to get information about a story I am already working on
  As a developer
  I want to type PT show and get details of the story

  Scenario: view description
    Given I am in the project folder
    And there are two stories in the backlog
    And the first story has a description
    And the second has no description
    When I show the first story
    Then I should see its description
    When I show the second story
    Then I should see that there is no description

  Scenario: view comments
    Given I am in the project folder
    And there are two stories in the backlog
    And the first one has no comments
    And the second has two comments
    When I show the first story
    Then I should see that it has no comments
    When I show the second story
    Then I should see that it has two comments
    And I should see when the comments were made
    And I should see who made the comments
