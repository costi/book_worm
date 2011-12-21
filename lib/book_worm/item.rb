require 'date'
class BookWorm::Item
  ATTRIBUTES = [:title, :status, :due_date, :pickup_by]
  ATTRIBUTES.each do |attr|
    attr_accessor attr 
  end

  def due_date=(new_date)
    case new_date
    when Date, NilClass
      @due_date = new_date
    else
      raise ArgumentError, "due date requires to pass in a Date object or nil"
    end
  end
  
  def pickup_by=(new_date)
    case new_date
    when Date, NilClass
      @pickup_by = new_date
    else
      raise ArgumentError, "pickup_by requires to pass in a Date object or nil"
    end
  end

  def initialize(attrs = {})
    self.attributes = attrs
  end

  def attributes
    hash = {}
    ATTRIBUTES.each {|attr| hash[attr] = send(attr)}
    hash
  end

  def attributes=(attrs)
    ATTRIBUTES.each {|attribute_name| send("#{attribute_name}=", attrs[attribute_name])}
  end

end
