# frozen_string_literal: true

exit if ENV['BUNDLE_UPDATE']

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'

RSpec.configure do |config|
  config.order = :random
  config.render_views

  config.before(:suite) do
    DatabaseRewinder[:active_record, connection: 'test']
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
    Rails.cache.clear
  end
end
