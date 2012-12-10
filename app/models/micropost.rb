class Micropost < ActiveRecord::Base
  
  # Listing 10.7
  #attr_accessible :content, :user_id
  attr_accessible :content

  # Listing 10.10
  belongs_to :user

  # Listing 10.4
  validates :user_id, presence: true
end
