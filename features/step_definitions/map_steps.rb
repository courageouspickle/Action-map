# frozen_string_literal: true

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

Given(/^(?:|I )am on (.+)$/) do |page_name|
    visit path_to(page_name)
end

When(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in(field, with: value)
end

When(/^(?:|I )press "([^"]*)"$/) do |button|
    click_button(button)
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
    if page.respond_to? :should
        page.should have_content(text)
    else
        assert page.has_content?(text)
    end
end

Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
    if page.respond_to? :should
        page.should have_no_content(text)
    else
        assert page.has_no_content?(text)
    end
end

When(/^(?:|I )check out "([^"]*)"$/) do |link|
    click_link(link)
end
