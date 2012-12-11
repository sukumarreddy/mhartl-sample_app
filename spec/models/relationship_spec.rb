require 'spec_helper'

describe Relationship do
  
  # Listing 11.2
  let(:follower) { FactoryGirl.create(:user) } # roughly equivalent to creating instance variable
  let(:followed) { FactoryGirl.create(:user) } # mhartl considers "let" to be cleaner.
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  # Listing 11.5
  describe "follower methods" do    
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end

end
