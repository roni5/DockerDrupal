@anon @javascript @screenshot @about
Feature: About us section
  In order to fine out about DataPoints
  As any user
  I want to find information About us

  @parallel-scenario
  Scenario: Browse to Contact us page
    Given I am on the homepage
    # When I follow "Contact Us"
    # And I wait until the page loads
    Then I should see "About Us"
  # @parallel-scenario
  # Scenario: Browse to Terms & Conditions page
  #   Given I am on the homepage
  #   When I follow "Terms & Conditions"
  #   And I wait until the page loads
  #   And I wait 2 seconds
  #   Then I should see "These terms and conditions"
  # @parallel-scenario
  # Scenario: Browse to Cookie Policy page
  #   Given I am on the homepage
  #   When I follow "Cookie Policy"
  #   And I wait until the page loads
  #   And I wait 2 seconds
  #   Then I should see "What are cookies?"
