require 'nokogiri'
require 'bigdecimal'  #for fine amount
class BookWorm::CplParser
  
  # options is a hash of documents
  # if we have all items in a single page, pass :all
  def initialize(options)
    if options[:all]
      @held_items_doc = @checked_out_items_doc = @overdue_items_doc = @total_fine_amount_doc = options[:all]
    end
    
  end

  def held_items
    doc = Nokogiri::HTML(@held_items_doc)
    # I go the the holds text and then I go to its parent to get to the table containing the holds 
    rows = doc.css('h3#holds').first.parent.parent.css('table tr')
    rows.delete(rows.first)  # exclude the header
    items = []
    rows.each do |row|
      row = row.css('td')
      items << {:title => row[1].content, :status => row[2].content, :pickup_by => self.class.parse_date(row[4].content)}
    end
    items
  end

  def checked_out_items
    doc = Nokogiri::HTML(@checked_out_items_doc)
    # I go the the checkedout text and then I go to its parent to get to the table containing the items 
    rows = doc.css('h3#checkedOut').first.parent.parent.css('table tr')
    rows.delete(rows.first)  # exclude the header
    items = []
    rows.each do |row|
      row = row.css('td')
      items << {:title => row[1].content, :status => 'Checked out', :due_date => self.class.parse_date(row[3].content)}
    end
    items
    
  end
  
  def overdue_items
    doc = Nokogiri::HTML(@overdue_items_doc)
    # I go the the Overdue text and then I go to its parent to get to the table containing the items 
    rows = doc.css('h3#overdues').first.parent.parent.css('table tr')
    rows.delete(rows.first)  # exclude the header
    items = []
    rows.each do |row|
      row = row.css('td')
      items << {:title => row[1].content, :status => 'Overdue', :due_date => self.class.parse_date(row[3].content)}
    end
    items
  end
  
  def total_fine_amount
    doc = Nokogiri::HTML(@total_fine_amount_doc)
    amount = doc.css('div.mycpl_green').last.css('table tr').last.css('td').last.content.delete('$')
    BigDecimal.new(amount)
  end

  def self.parse_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end
  
end
