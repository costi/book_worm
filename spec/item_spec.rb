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
    item.due_date = '2011-12-12'
    item.due_date.should == '2011-12-12'
  end
  it 'has a pickup_by date' do
    item.pickup_by = '2011-12-12'
    item.pickup_by.should == '2011-12-12'
  end

  describe 'attributes hash' do
    ATTRS = Hash[:title => 'Title', :status => 'Status', :due_date => '2011-12-12', :pickup_by => '2011-12-29'] 
    let(:attributes){ ATTRS }
    let(:item){ described_class.new(ATTRS) } #scoping fun

    it 'initializes with a hash of attributes' do
      item.title.should == 'Title'
      item.status.should == 'Status'
      item.due_date.should == '2011-12-12'
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
