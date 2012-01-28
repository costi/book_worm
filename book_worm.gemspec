# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "book_worm/version"

Gem::Specification.new do |s|
  s.name        = "book_worm"
  s.version     = BookWorm::VERSION
  s.authors     = ["Constantin Gavrilescu"]
  s.email       = ["comisarulmoldovan@gmail.com"]
  s.homepage    = "http://github.com/costi/book_worm"
  s.summary     = %q{This gem fetches your activity from the Chicago Public Library website}
  s.description = %q{Use it to get your late fees, know when an item becomes available, etc}

  s.rubyforge_project = "book_worm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here:
  s.add_development_dependency "rspec", ">= 1.8.0"  # for default tags feature: to exclude live test by default
  #s.add_development_dependency "hoe"
  s.add_development_dependency "cucumber" 
  s.add_development_dependency "capybara" # for integration testing
  s.add_development_dependency "shotgun"  # Development mode for sinatra
  s.add_development_dependency "sinatra"  # for the mock website in integration testing
  s.add_runtime_dependency "nokogiri"   # to parse the pages
  s.add_runtime_dependency "mechanize"  # to browse the cpl website

end
