require 'spec_helper'

describe "Static pages" do

  # Listing 3.30
  let(:base_title) { "Ruby on Rails Sample App" }
  
  # Listing 3.9
  describe "Home page" do
  
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')       
    end
    
    # Listing 3.17 - goes here?
    it "should have the right title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "#{base_title} | Home")
    end
  end
  
  # Listing 3.11
  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end
    
    # Listing 3.18
    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title',
                        :text => "#{base_title} | Help")
    end
    
  end

  # Listing 3.13
  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end
    
    # Listing 3.18
    it "should have the title 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('title',
                    :text => "#{base_title} | About Us")
    end
    
  end
  
  
end
