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
  it { should respond_to :authenticate }



  # Listing 6.11
  it { should be_valid }
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



end
