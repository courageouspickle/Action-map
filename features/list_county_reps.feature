Feature: Display the search page with representatives from a county when that county is clicked
 
  As a politically active citizen
  So that I can navigate to my representative
  I want to see the representatives of a county when I click it.

Background: I am on the ActionMap page

  Given I am definitely on the ActionMap home page

Scenario: Select California, then Alameda County
  When I click the state "CA"
  When I click "Alameda County"
  
Scenario: Select Kansas, then Pawnee Country
  When I click the state "KS"
  When I click "Pawnee County"