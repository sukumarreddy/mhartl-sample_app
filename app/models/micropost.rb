class Micropost < ActiveRecord::Base
  attr_accessible :content, :user_id

  # Listing 10.4
  validates :user_id, presence: true
end
