Feature: Index page
 The index page needs to load correctly
 
 @javascript
 Scenario: Visit index page
  Given I am on the home page
  Then I should see "Picasa Gallery" within "//h1"
  
 @javascript
 Scenario: Click lightbox thumbnail
  Given I go to the home page
  When I click lightbox thumbnail "//a[@rel='gallery1']"
  Then "//div[@id='cboxOverlay']" should be present
  
 Scenario: Go to next page
  Given I go to the home page
  When I follow "2" within "//li[@class='page-2']"
  Then "//li[@class='page-2 active']" should be present