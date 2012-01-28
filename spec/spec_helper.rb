require 'rubygems'
require 'rspec'
require 'book_worm'
require 'cpl_test'
RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.filter_run_excluding :live
end
