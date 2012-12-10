require 'spec_helper'

describe Micropost do

  # Listing 10.2
  let(:user) { FactoryGirl.create(:user) }
  before do

    # Listing 10.5
    # This code is wrong! [Section 10.1.2 bottom: mass-assignment by user_id is enabled by default]
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
    @micropost = user.microposts.build(content: "Lorem ipsum")

  end 

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  # Listing 10.8
  it { should respond_to(:user) }
  its(:user) { should == user }

  # Listing 10.3
  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  # Listing 10.7 - validations
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 } # remember string multiplication? (Section 6.2)
    it { should_not be_valid }
  end

  # Listing 10.5
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
