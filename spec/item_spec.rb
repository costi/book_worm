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
end
