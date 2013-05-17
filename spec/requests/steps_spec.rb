require 'spec_helper'

describe "Welcome" do
  describe "GET /" do
    it "shows the welcome page" do
      visit root_path
       page.should have_content("step")
    end
  end
end

describe "Steps" do
  describe "Step 1" do
    it "lets user enters address and get started" do
      visit root_path
      fill_in 'address[base58]', with: "1KHxSzFpdm337XtBeyfbvbS9LZC1BfDu8K"
      click_button "Get Started"
      page.should have_content "Name"
    end
    
    it "lets user get started without entering address" do
      visit root_path
      click_button "Get Started"
      page.should have_content "Name"
    end
    
    it "validates the address" do
      visit new_address_path
      fill_in 'address[base58]', with: "1KHxSzFpdm337XtBeyfbvbS9LZC1BfDu8K"
      click_button "Check address"
      page.should have_content "can't be blank"
    end
    
    it "takes the user to step 2 if all is well" do
      visit new_address_path
      fill_in 'address[base58]', with: "1KHxSzFpdm337XtBeyfbvbS9LZC1BfDu8K"
      fill_in 'address[name]', with: "Mobile Wallet"
      click_button "Check address"
      page.should have_content "Address was found"
    end
  end
end