require 'spec_helper'

describe "Static pages" do

  # Listing 3.30
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  # Listing 5.27
  subject { page }

  # Listing 5.35 (Exercise 5.1)
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end


  # Listing 3.9
  describe "Home page" do

    #it "should have the h1 'Sample App'" do
    #  #visit '/static_pages/home'
    #  #visit root_path # Listing 5.20
    #  page.should have_selector('h1', :text => 'Sample App')       
    #end
    
    ## Listing 3.17 - goes here?
    #it "should have the base title" do
    #  #visit '/static_pages/home'
    #  #visit root_path
    #  page.should have_selector('title', :text => "#{base_title}")
    #end

    # Listing 4.4 
    #it "should not have a custom page title" do
    #  #visit '/static_pages/home'
    #  #visit root_path
    #  page.should_not have_selector('title', :text => '| Home')
    #end
    
    # Listing 5.27
    before { visit root_path }
    #it { should have_selector('h1', :text => 'Sample App') }
    #it { should have_selector('title', :text => full_title('')) }
    it { should_not have_selector('title', :text => '| Home') }

    # Listing 5.35
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"

  end
  
  # Listing 3.11
  describe "Help page" do
  
    #it "should have the content 'Help'" do
    #  #visit '/static_pages/help'
    #  visit help_path # Listing 5.20
    #  page.should have_selector('h1', :text => 'Help')
    #end
    #
    ## Listing 3.18
    #it "should have the title 'Help'" do
    #  #visit '/static_pages/help'
    #  visit help_path
    #  page.should have_selector('title', :text => "#{base_title} | Help")
    #end
    
    # Listing 5.27
    before { visit help_path }
    #it { should have_selector('h1', text: 'Help') }
    #it { should have_selector('title', text: full_title('Help')) }    

    # Exercise 5.1
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"

  end

  # Listing 3.13
  describe "About page" do
    # it "should have the content 'About Us'" do
    #   #visit '/static_pages/about'
    #   visit about_path # Listing 5.20
    #   page.should have_selector('h1', :text => 'About Us')
    # end
    # 
    # # Listing 3.18
    # it "should have the title 'About Us'" do
    #   #visit '/static_pages/about'
    #   visit about_path
    #   page.should have_selector('title', :text => "#{base_title} | About Us")
    # end
    
    # Listing 5.27
    before { visit about_path }
    #it { should have_selector('h1', text: 'About') }
    #it { should have_selector('title', text: full_title('About')) }  

    # Exercise 5.1
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  # Listing 5.16
  describe "Contact page" do
    # it "should have the h1 'Contact'" do
    #   visit contact_path
    #   page.should have_selector('h1', text: 'Contact')
    # end
    # 
    # it "should have the title 'Contact'" do
    #   visit contact_path
    #   page.should have_selector('title', text: "#{base_title} | Contact")
    # end

    # Listing 5.27
    before { visit contact_path }
    #it { should have_selector('h1', text: 'Contact') }
    #it { should have_selector('title', text: full_title('Contact')) } 

    # Exercise 5.1
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end
  
  # Listing 5.36 + Exercise 5.2 (integration test)
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end
  
end
