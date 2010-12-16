require "spec_helper"

# Use rspec if we need to test more complex things.

describe "index" do
  include TestHelper

  it "should render successfully" do
    get "/"
    last_response.should be_ok
  end

end