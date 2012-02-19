require 'mechanize'

module BookWorm
  class CrawlError < Exception;
    attr_reader :page, :message
    def initialize(a_message, a_page)
      @message = a_message
      @page = a_page
    end
  end

  class CplCrawler
    attr_reader :library_card, :zip_code, :http_agent, :errors
    attr_accessor :start_url
    ERRORS_TO_RESCUE_FROM = [Mechanize::Error, CrawlError]

    def initialize(new_library_card, new_zip_code, new_start_url = 'http://www.chipublib.org/mycpl/login/')
      @library_card = new_library_card
      @zip_code = new_zip_code
      @account_detail_page = nil
      @http_agent = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }
      @start_url = new_start_url
      @errors = {}
    end

    # crawl() rescues any crawl errors and puts them in the errors hash.
    def crawl
      # TODO flush the page cache. We cache the crawled pages.
      begin
        account_detail_page #This will get us as far as we want to go, through several pages
      rescue *ERRORS_TO_RESCUE_FROM => e
        errors[:message] = e.message
        errors[:page_url] = e.page.uri
        errors[:page_body] = e.page.body
        return nil
      end
    end

    def holds_page
      crawl  
    end

    def checked_out_page
      crawl
    end

    def overdue_page
      crawl
    end

    def fines_page
      crawl
    end

    private

    # Workflow:
    # login_page -> fill login form -> click -> get home page => get account_detail page

    def login_page 
      @login_page ||= http_agent.get(start_url)
    end

    def login_form
      @login_form ||= login_page.form_with(:action => '/mycpl/login/') or  
        raise CrawlError.new('Cannot find the login form in the login page', login_page)
    end

    def filled_in_login_form
      login_form.patronId = self.library_card
      login_form.zipCode = self.zip_code
      login_form
    end

    def login!
      @home_page = filled_in_login_form.click_button
    end

    # we still get a HTTP 200 on failed login so we detect failed login after the page we land on
    def logged_in?
      !!link_to_account_detail_page
    end

    def home_page
      @home_page ||= login!
    end

    def link_to_account_detail_page
      link = home_page.link_with(:text => /Checked Out/) or
        raise CrawlError.new('Failed login / Cannot find the link to account_detail page', home_page)
    end

    def account_detail_page
      @account_detail_page ||= link_to_account_detail_page.click
    end

  end
end
