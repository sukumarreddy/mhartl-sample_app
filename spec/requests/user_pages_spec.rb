# Generated in Section 5.4.2 by "rails generate integration_test user_pages"
require 'spec_helper'

describe "UserPages" do

  #describe "GET /user_pages" do
  #  it "works! (now write some real specs)" do
  #    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #    get user_pages_index_path
  #    response.status.should be(200)
  #  end
  #end

  # Listing 5.31 - modified to be "pretty"
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1', text:'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  # Listing 7.9
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    # Listing 10.19 - with let!() to make association exist immediately
    let!(:m1) { FactoryGirl.create(:micropost, user:user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user:user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }

    # Listing 10.19 cont.
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) } # n.b. count() "through" the association
    end

    # Listing 11.32
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end # "follow/unfollow buttons"

  end # "profile page"

  # Listing 7.16
  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do # signup information is blank unless specified otherwise
        expect { click_button submit }.not_to change(User, :count) # invalid user should not get committed to db
      end                                                          # {} syntax for change() invocation
                                                                   # User.count computed before and after {}
      # Listing 7.31 + Exercise 7.2
      describe "after submission" do
        before { click_button submit }
  
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }

        # my additions
        # it { should have_content('Password digest can\'t be blank') } # Removed in Exercise 7.3!
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Email is invalid') }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
        it { should have_content('Password confirmation can\'t be blank') }

      end

    end                                                            

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User" # (supposedly) valid signup information
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        
        # Exercise 9.5 - consolidated into Listing 9.50 partial
        #fill_in "Confirmation", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      # Listing 7.32 + Exercise 7.4
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        # Listing 8.26 - polish: should be signed in after signing up
        it { should have_link 'Sign out' }

      end
    end

  end # "signup"

  # Listing 9.1
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do 
      # Listing 9.13 - now require signed in user to edit entries
      sign_in user

      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    # Listing 9.9
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name } # n.b. reload()
      specify { user.reload.email.should == new_email }
    end

  end # "edit"

  # Listing 9.23
  describe "index" do

    # Listing 9.33
    # before do
    #   sign_in FactoryGirl.create(:user)
    #   FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
    #   FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
    #   visit users_path
    # end
    let (:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    # Listing 9.33
    # it "should list each user" do
    #   User.all.each do |user|
    #     page.should have_selector('li', text: user.name)
    #   end
    # end
    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector 'div.pagination' }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector 'li', text: user.name
        end
      end
    end

    # Listing 9.44
    describe "delete links" do
      it "cannot delete before logging in as admin" do 
        should_not have_link 'delete' 
      end

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end

        it "should not see a link to delete self" do
          should_not have_link('delete', href: user_path(admin))
        end
      end # "as an admin user"
    end # "delete links"

  end # "index"

  # Listing 11.29
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end # "following/followers"

end # UserPages
