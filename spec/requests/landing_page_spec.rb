require 'spec_helper'

describe "Welcome" do
  describe "GET /" do
    it "shows the welcome page" do
      visit root_path
       page.should have_content("soon")
    end
  end
end