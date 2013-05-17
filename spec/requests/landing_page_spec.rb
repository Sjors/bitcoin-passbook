require 'spec_helper'

describe "HelloWorld" do
  describe "GET /" do
    it "shows the rails welcome page" do
      visit root_path
       page.should have_content("soon")
    end
  end
end