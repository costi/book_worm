require 'date'
class Item
  ATTRIBUTES = [:title, :status, :due_date, :pickup_by]
  ATTRIBUTES.each do |attr|
    attr_accessor attr 
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
