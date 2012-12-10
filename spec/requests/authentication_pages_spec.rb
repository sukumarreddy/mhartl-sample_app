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
        # Exercise 8.2 - giving it a whirl
        #fill_in "Email", with: user.email
        #fill_in "Password", with: user.password
        #click_button "Sign in"
        #valid_signin(user) # overridden in Listings 9.5-9.6

        # Listing 9.5
        sign_in user
      end

      it { should have_selector 'title', text: user.name }
      it { should have_link 'Profile', href: user_path(user) }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }

      # Listing 9.5
      it { should have_link 'Settings', href: edit_user_path(user) }

      # Listing 9.27 
      it { should have_link 'Users', href: users_path }

      # Listing 8.28
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link "Sign in" }
      end
    end # "with valid information"
  end # "signin action"

  # Listing 9.11
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) } # n.b. direct HTTP request
          specify { response.should redirect_to(signin_path) } # direct request yields low-level "response" object
        end

        # Listing 9.21
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

      end

      # Listing 10.26
      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path } # /microposts
          specify { response.should redirect_to(signin_path) } 
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      # Listing 9.17 "friendly forwarding"
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end

          # Listing 9.52 (Exercise 9.8) - no double-render
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end

        end # "after signing in"        
      end # "when attempting to visit a protected page"

      # Exercise 9.3
      describe "non-signed-in users should not have user profile or settings" do
        it { should_not have_link 'Profile', href: user_path(user) }
        it { should_not have_link 'Settings', href: edit_user_path(user) }
      end

    end # "for non-signed-in users"

    # Listing 9.14
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") } # factory options!
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end # "as wrong user"

    # Listing 9.47
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    # Exercise 9.9 + comments below Listing 9.46
    describe "admin user should not be able to DELETE yourself" do
      let(:admin) { FactoryGirl.create(:admin) }        
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in admin # cf. user_pages_spec / Listing 9.44
      end

      describe "deleting other users should be fine" do
        before { delete user_path(user) }
        specify { response.should redirect_to(users_path) }

        # ugh, could not get this to work, which WOULD have been better...
        #specify { page.should have_content "User destroyed" }
      end

      describe "deleting yourself should not work" do
        before { delete user_path(admin) }
        specify { response.should_not redirect_to users_path }
      end
      
      
    end

  end # "authorization"

end
