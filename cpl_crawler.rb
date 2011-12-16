require 'mechanize'
class CplCrawler
  attr_reader :library_card, :zip_code

  def initialize(new_library_card, new_zip_code)
    @library_card = new_library_card
    @zip_code = new_zip_code
    @summary_page = nil
    @agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
  end

  def login_to_library
    @agent.get('http://www.chipublib.org/mycpl/login/') do |login_page|
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
  def summary_page
    @summary_page ||= @agent.click( @homepage.links.text(/Checked Out/) )
  end
  
  
end
