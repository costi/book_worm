#encoding: UTF-8
require 'spec_helper'
require File.join(AppRoot, 'cpl_parser')
require 'date'

describe CplParser do
  let(:fixture_path) { File.join(File.dirname(__FILE__), 'html_pages', 'cpl')}
  
  
  it "should parse fines" do
    p = CplParser.new(:all => File.read(File.join(fixture_path, "just_fines.html")))
    p.total_fine_amount.should == 10 
  end

  it 'should get the correct number of held_items' do
    p = CplParser.new(:all => File.read(File.join(fixture_path, 'checked_out_overdue_on_hold.html')))
    p.held_items.size.should == 4
  end

  it 'should parse a held items row' do
    p = CplParser.new(:all => File.read(File.join(fixture_path, 'checked_out_overdue_on_hold.html')))
    held_item = p.held_items.first
    held_item[:title].should == 'Mon dernier soupir /'
    held_item[:status].should == 'Ready for pickup'
    held_item[:pickup_by].should == Date.parse('2009-11-13')
  end
 
  it 'should get the correct number of checked out items' do
    p = CplParser.new(:all => File.read(File.join(fixture_path, 'checked_out_overdue_on_hold.html')))
    p.checked_out_items.size.should == 5         
  end

  # checked out items don't include the overdue items in 
  it 'should parse a checked out items row' do
    p = CplParser.new(:all => File.read(File.join(fixture_path, 'checked_out_overdue_on_hold.html')))
    co_item = p.checked_out_items.first
    co_item[:title].should == 'Sexo para dummies /'
    co_item[:status].should == 'Checked out'
    co_item[:due_date].should == Date.parse('2009-11-18')
  end
  
  it 'should parse items with extra Spanish characters in it' do
    p = CplParser.new(:all => File.read(File.join(fixture_path, 'checked_out_overdue_on_hold.html')))
    p.checked_out_items[1][:title].should == 'El vendedor de sueños'
    p.checked_out_items[2][:title].should == 'Cómo iniciar su propio negocio /'
  end

  it 'parses the due_date in american format' do
    CplParser.parse_date('11/18/2009').should == Date.parse('2009-11-18')
  end

end
