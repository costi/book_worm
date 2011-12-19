require 'mechanize'
class CplCrawler
  attr_reader :library_card, :zip_code, :http_agent

  def initialize(new_library_card, new_zip_code)
    @library_card = new_library_card
    @zip_code = new_zip_code
    @summary_page = nil
    @http_agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
  end

  def login_to_library
    http_agent.get('http://www.chipublib.org/mycpl/login/') do |login_page|
      @homepage = login_page.form_with(:action => '/mycpl/login/') do |f|
        f.patronId = self.library_card
        f.zipCode = self.zip_code
      end.click_button
    end
    @homepage
  end

  def holds_page
    summary_page  
  end
  
  def checked_out_page
    summary_page
  end

  def overdue_page
    summary_page
  end
  
  def fines_page
    summary_page
  end
  
  private

  # Workflow:
  # login_page -> fill login form -> click -> get home page => get summary page
  
  def login_page 
    @login_page ||= http_agent.get('http://www.chipublib.org/mycpl/login/')
  end

  def login_form
    @login_form ||= login_page.form_with(:action => '/mycpl/login/') 
  end

  def filled_in_login_form
    login_form.patronId = self.library_card
    login_form.zipCode = self.zip_code
    login_form
  end

  def login!
    @home_page = filled_in_login_form.click_button
  end

  def home_page
    @home_page ||= login!
  end

  def summary_page_link
    home_page.links.text(/Checked Out/)
  end
  
  def summary_page
    @summary_page ||= http_agent.click( summary_page_link )
  end
end
