require "bundler/gem_tasks"
require 'rspec/core/rake_task'

Spec::Core::RakeTask.new(:live_test) do |t|
  t.pattern = './integration_test/live_test_spec.rb'
  t.rspec_opts = '--tag live'
end

Spec::Core::RakeTask.new(:integration_test) do |t|
  t.pattern = './integration_test/*_spec.rb'
end


