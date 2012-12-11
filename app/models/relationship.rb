class Relationship < ActiveRecord::Base
  
  # Listing 11.6 - override Rails' auto-generated accessibility
  #attr_accessible :followed_id, :follower_id
  attr_accessible :followed_id

  # Listing 11.6
  belongs_to :follower, class_name: "User" # override Rails' default of Follower
  belongs_to :followed, class_name: "User" # override Rails' default of Followed

  # Listing 11.8
  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
