Feature: Display the search page with representatives from a county when that county is clicked
 
  As a politically active citizen
  So that I can navigate to my representative
  I want to see the representatives of a county when I click it.

Background: I am on the ActionMap page

  Given I am on the ActionMap home page

Scenario: Select California, then Alameda County
  When I click "California"
  When I click "Alameda County"
  Then I should see "Gregory J. Ahern"
  
Scenario: Select Kansas, then Pawnee Country
  When I click "Kansas"
  when I click "Pawnee County"
  Then I should see "Tami Keenan"