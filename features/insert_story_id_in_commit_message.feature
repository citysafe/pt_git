Feature: Insert the story ID from the current branch into the commit message by default
  In order to determine which story a commit belongs to
  As a developer
  I want to have the story ID in the commit message by default

  Scenario: Insert the story ID from the current branch into the commit message by default
    Given I am on a branch that contains the story ID
    When I make a commit
    Then I should see the story ID in the commit message
