require 'mechanize'

module BookWorm
  class CrawlError < Exception; end

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
      rescue CrawlError => e
        errors[:crawl] = e.message
        return nil
      rescue Mechanize::ResponseCodeError => e
        errors[:mechanize] = e.message
        errors[:page_url] = e.page.uri
        return nil
      end
    end

    def holds_page
      account_detail_page  
    end
    
    def checked_out_page
      account_detail_page
    end

    def overdue_page
      account_detail_page
    end
    
    def fines_page
      account_detail_page
    end
    
    private

    # Workflow:
    # login_page -> fill login form -> click -> get home page => get account_detail page
    
    def login_page 
      @login_page ||= http_agent.get(start_url)
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

    # we still get a HTTP 200 on failed login so we detect failed login after the page we land on
    def logged_in?
      !!link_to_account_detail_page
    end

    def home_page
      @home_page ||= login!
    end

    def link_to_account_detail_page
      link = home_page.link_with(:text => /Checked Out/)
      if !link
        raise CrawlError, 'Cannot find the link to account_detail page'
      end
      link
    end
    
    def account_detail_page
      @account_detail_page ||= link_to_account_detail_page.click
    end

  end
end
