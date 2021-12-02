require 'uri'
require 'cgi'

Given(/I am definitely on the ActionMap home page/) do
    visit path_to('the home page')
end

When(/I click the state "([^"]*)"/) do |_state|
    '/'
end

When(/I click "([^"]*)"/) do |_thing|
    '/'
end
