sinatrapid = fork do
  log = File.open('sinatra.log', 'a+')
  STDOUT.reopen(log)
  STDERR.reopen(STDOUT)
  STDIN.close
  puts 'requiring cpl.rb...'
  require File.dirname(__FILE__) + '/../../test_server/cpl.rb'
  puts 'attempting to start the server...'
  MockCpl.run!
  f.close
end


require_relative '../../spec/cpl_test'
include BookWorm::CplTest

require 'rspec'
World do
  include RSpec::Matchers
end

=begin
Before do
#use threads
  # thread.run, thread.start
  #  thread.join
      def assemble_app
      config = @config
      inner_app = self.inner_app
      Rack::Builder.new {
        instance_eval(&config)
        run inner_app
      }.to_app
    end

    def inner_app
      if rackup_file =~ /\.ru$/
        config = File.read(rackup_file)
        eval "Rack::Builder.new {( #{config}\n )}.to_app", nil, rackup_file
      else
        require File.expand_path(rackup_file)
        if defined? Sinatra::Application
          Sinatra::Application.set :reload, false
          Sinatra::Application.set :logging, false
          Sinatra::Application.set :raise_errors, true
          Sinatra::Application
        else
          Object.const_get(camel_case(File.basename(rackup_file, '.rb')))
        end
      end
    end
=end 


sinatra_spinup_timeout = 5
begin 
  Timeout.timeout(sinatra_spinup_timeout) do 
    puts "waiting #{sinatra_spinup_timeout} seconds for the server mock server to start"
    sleep 2 
    `curl http://localhost:4567`
  end
rescue Timeout::Error
  puts 'Could not start mock server. See log file.'
end

# Rack::Server.start with option to daemonize
# /home/costi/.rvm/gems/ruby-1.9.2-p180@bookr/gems/rack-1.4.0/lib/rack/server.rb
# or fork and do rackup 

at_exit do
  Process.kill "TERM", sinatrapid 
  Process.waitall
end
