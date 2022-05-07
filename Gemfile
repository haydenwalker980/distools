# frozen_string_literal: true

source "https://rubygems.org"

# Ok so uhhh i think uhhh testing uhhh basic deps uhhh
gem "rake", "~> 13.0"
# I have a newer rspec
# gem "rspec", "~> 3.0"
gem "rubocop", "~> 1.21"
# discord shit
gem 'discorb'
%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'main'
end
