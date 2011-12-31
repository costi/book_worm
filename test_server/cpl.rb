#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require_relative '../spec/cpl_test'
include BookWorm::CplTest

class MockCpl < Sinatra::Base
  get '/' do
    "mock cpl server for integration testing"
  end

  get '/mycpl/login/' do
    File.read(LOGIN_PAGE)
  end

  post '/mycpl/login/' do
    if params['patronId'] == LIBRARY_CARD_OK && params['zipCode'] == ZIP_CODE_OK 
      File.read(HOME_PAGE) # from this page we click to the summmary page
    else
      File.read(FAILED_LOGIN_PAGE)
    end
  end

  # The page with all the data in: holds, checked out items, etc
  get '/mycpl/summary/' do
    File.read(SUMMARY_PAGE)
  end
end
