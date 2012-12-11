# Annotations generated using 'bundle exec annotate'
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  # Listing 6.8
  before do 
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar" # Listing 6.27 adds password
    )
  end
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }

  # Listing 6.25
  it { should respond_to(:password_digest) } 

  # Listing 6.27
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  # Listing 6.29
  it { should respond_to :authenticate }

  # Listing 8.15
  it { should respond_to :remember_token }
  #it { should respond_to :authenticate } # oops, redundant

  # Listing 9.39
  it { should respond_to :admin }

  # Listing 10.9
  it { should respond_to :microposts }

  # Listing 10.38 - status feed
  it { should respond_to :feed }

  # Listing 11.3
  it { should respond_to :relationships }

  # Listing 11.9
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }

  # Listing 11.15
  it { should respond_to :reverse_relationships }
  it { should respond_to :followers }

  # Listing 11.11
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  # Listing 11.13
  it { should respond_to :unfollow! }

  # Listing 6.11
  it { should be_valid }

  # Listing 9.39
  it { should_not be_admin }

  # Listing 6.11
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # Listing 6.12
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # Listing 6.14 - arbitrarily set max # chars = 50 for name
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # Listing 6.16 - email validation (beyond non-blank)
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  # Listing 6.18 - email uniqueness
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.swapcase # Listing 6.20 - with my modification
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # I really wanted to add this because new code without a test just felt WRONG
  # turns out this is actually:
  # Listing 6.31 / Exercise 6.1
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as all lowercase" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  # Listing 6.28
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do # COULD happen at the console..
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  # Listing 6.29
  describe "return value of authenticate method" do    
    before { @user.save } # save to db for find_by_email
    let(:found_user) { User.find_by_email @user.email } # Box 6.3 describes "let" (local test vars)

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) } # hmm, parentheses required for authenticate()
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate "invalid" } # doesn't hit db again ("memoized" from previous test)

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false } # it == specify (readability)
    end
  end
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  # Listing 8.17
  describe "remember token" do
    before { @user.save } 
    its(:remember_token) { should_not be_blank } # introducing "its"!
  end

  # Listing 9.39
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle! :admin # note toggle!() method
    end
    it { should be_admin } # RSpec convention implies existence of User#admin?()
  end

  # Exercise 9.1 - following Listing 10.8
  describe "Exercise 9.1" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  # Listing 10.13
  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do # let!() forces immediate evaluation (instead of lazy)
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) # factories bypass attr_accessible and magic timestamps
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) # note Rails' time helpers
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost] # <--- the key line.
    end

    # Listing 10.15
    it "should destroy associated microposts" do
      microposts = @user.microposts.dup # copy array (else just copies reference)
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil # find_by_id() returns nil if record not found
      end
    end

    # Listing 10.38
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) } # RSpec correctly interprets as array inclusion, not include keyword
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }

      # Listing 11.41
      let(:followed_user) { FactoryGirl.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end

    end

  end # "micropost associations"

  # Listing 11.11
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    # Listing 11.15
    describe "followed user" do
      subject { other_user } # notice subject switching
      its(:followers) { should include(@user) }
    end

    # Listing 11.13
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

  end # "following"

  # Exercise 11.1
  describe "relationship associations" do

    # from "following" tests
    let(:other_user) { FactoryGirl.create(:user) }
    before do 
      @user.save
      @user.follow!(other_user)
    end
    

    # cf. Listing 10.15
    it "should destroy associated relationships" do
      relations = @user.relationships.dup # copy array (else just copies reference)
      relations.should_not be_empty
      @user.destroy
      relations.should_not be_empty
      relations.each do |rel|
        Relationship.find_by_id(rel.id).should be_nil # find_by_id() returns nil if record not found
      end
    end
  end


end # User
