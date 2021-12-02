Feature: show representatives profile when search by address and click on representatives' name

    As a registered voter
    So that I can enter address in search bar and find out more information about a representative
    I want to see a profile of the chosen representative
 
 Background: representative data in database
 
 Scenario: Search for representative address in search field 1
  Given I am on the representatives page
  When I fill in "address" with "California"
  And I press "Search"
  Then I should see "Joseph R. Biden"
  And I should see "Betty T. Yee"
  And I should not see "Mitch McConnell"
  When I check out "Dianne Feinstein"
  Then I should see "Dianne Feinstein"
  Then I should see "Democratic Party"
  And I should see "U.S. Senator"
  
    

