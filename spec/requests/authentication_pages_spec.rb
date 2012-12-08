require 'spec_helper'

describe "AuthenticationPages" do
  #describe "GET /authentication_pages" do
  #  it "works! (now write some real specs)" do
  #    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #    get authentication_pages_index_path
  #    response.status.should be(200)
  #  end
  #end

  # Listing 8.1
  subject { page }
  describe "signin page" do
    before { visit signin_path }
    it { should have_selector 'h1', text: 'Sign in' }
    it { should have_selector 'title', text: 'Sign in' }
  end

  # Listing 8.5 - tests for signin failure
  describe "signin action" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_selector 'title', text: 'Sign in' } 
      it { should have_selector 'div.alert.alert-error', text:'Invalid' }

      # Listing 8.11 flash persists for 2 pages after 'render'
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector 'div.alert.alert-error' }
      end
    end

    # Listing 8.6 - test for signin success
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector 'title', text: user.name }
      it { should have_link 'Profile', href: user_path(user) }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }
    end

  end

end
