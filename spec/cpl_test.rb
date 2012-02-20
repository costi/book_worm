module BookWorm
  module CplTest
     HTML_PAGES = File.join(File.dirname(__FILE__), 'html_pages', 'cpl')
     LOGIN_PAGE = File.join(HTML_PAGES, "login_page.html")
     FAILED_LOGIN_PAGE = File.join(HTML_PAGES, "failed_login_page.html")
     HOME_PAGE = File.join(HTML_PAGES, "home_page.html")
     FINES_PAGE = File.join(HTML_PAGES, "just_fines.html")

     # checked_out_overdue_on_hold.html has:
     # 1 overdue items
     # 4 held items
     # 5 checked out items
     SUMMARY_PAGE = File.join(HTML_PAGES, 'checked_out_overdue_on_hold.html')

     LIBRARY_CARD_OK = 'd123456789' 
     ZIP_CODE_OK = '12345'
  end
end
