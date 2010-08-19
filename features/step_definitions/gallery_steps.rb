require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

When /^(?:|I )click lightbox thumbnail "([^\"]*)"/ do |link|
  locate("#{link}").click
end

Then /^"([^\"]*)" should be present/ do |selector|
  page.should have_xpath(selector)
end