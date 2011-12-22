#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

get '/' do
  "mock cpl server for integration testing"
end

get '/mycpl/login/' do
  File.read(BookWorm::CplTest::LOGIN_PAGE)
end


post '/mycpl/login/' do
  if params['patronId'] == 'd123456789' && params['zipCode'] == '12345'
    File.read(BookWorm::CplTest::HOME_PAGE) # from this page we click to the summmary page
  else
    File.read(BookWorm::CplTest::FAILED_LOGIN_PAGE)
  end
end

# The page with all the data in: holds, checked out items, etc
get '/mycpl/summary/' do
  File.read(BookWorm::CplTest::SUMMARY_PAGE)
end
