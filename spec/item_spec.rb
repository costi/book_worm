require 'spec_helper'
require File.join(AppRoot, 'item')
describe Item do
  let(:item){described_class.new}
  it 'has a title' do
    item.title = "A MAN"
    item.title.should == "A MAN"
  end
  it 'has a status' do
    item.status = "due"
    item.status.should == 'due'
  end
  it 'has a due date' do
    item.due_date = Date.parse('2011-12-12')
    item.due_date.should == Date.parse('2011-12-12')
  end
  it 'has a pickup_by date' do
    item.pickup_by = Date.parse('2011-12-12')
    item.pickup_by.should == Date.parse('2011-12-12')
  end
  it 'raises an exception if we pass anything but date to pickup_by' do
    lambda do
      item.pickup_by = '2011-12-12'
    end.should raise_exception(ArgumentError)
  end
  it 'raises an exception if we pass a string to due_date' do
    lambda do
      item.due_date = '2011-12-12'
    end.should raise_exception(ArgumentError)
  end
  it 'sets the due_date nil if we pass in nil to due_date=' do
    item.due_date = nil
    item.due_date.should == nil
  end

  describe 'attributes hash' do
    let(:attributes){               Hash[:title => 'Title', :status => 'Status', :due_date => Date.parse('2011-12-12'),
           :pickup_by => Date.parse('2011-12-29')]}
    let(:item){ described_class.new(Hash[:title => 'Title', :status => 'Status', :due_date => Date.parse('2011-12-12'), 
           :pickup_by => Date.parse('2011-12-29')])}

    it 'initializes with a hash of attributes' do
      item.title.should == 'Title'
      item.status.should == 'Status'
      item.due_date.should == Date.parse('2011-12-12')
      item.pickup_by.should == Date.parse('2011-12-29')
    end
    it 'sets attributes using the attributes hash' do
      new_attributes = attributes.merge(:title => 'New Title')
      item.attributes = new_attributes
      item.attributes.should == new_attributes
    end
    it 'gets attributes using the attributes hash' do
      item.attributes.should == attributes
    end
  end
end
