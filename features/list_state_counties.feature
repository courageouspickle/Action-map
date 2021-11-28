Feature: Display counties in a State when clicked
 
  As a politically active citizen
  So that I can navigate to my representative
  I want to see the counties within a state when I click it.

Background: I am on the ActionMap page

  And  I am on the ActionMap home page

Scenario: Select California
  When I click "California"
  Then I should see the following movies: Amelie, When Harry Met Sally, Raiders of the Lost Ark
  But I should not see the following movies: Aladdin, Chocolat, 2001: A Space Odyssey

Scenario: all ratings selected
  When I check the following ratings: G, PG, PG-13, R
  And I press "Refresh"
  Then I should see all the movies