#We should be able to test the crawler without internet access,
#on my mock cpl server. I don't always have
#internet access and I also don't want to run too many login
#sessions from the same library card to the CPL website.

Feature:
  As a user of the CPL library
  I want to be able to parse my user page with book_worm
  So I can save rental history and fines notifications

  Scenario: A CPL patron can parse his items from his homepage
    Given a CPL patron with 3 checked out items
    When I login to the website with his credentials
    Then I get to his homepage
    When I navigate to the summary page
    Then I find 3 checked out items

  Scenario: Wrong credentials lead to failed login
    Given a CPL patron with wrong credentials
    When I login to the website with his credentials
    Then I get the failed login page
