# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'bundler'
require 'bundler/setup'
require 'rspec/autorun'
require 'capybara/rspec'

Dir["spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  # config.use_transactional_fixtures = false
  config.order = "random"
end

module ::RSpec::Core
  class ExampleGroup
    include Capybara::DSL
    include Capybara::RSpecMatchers
  end
end