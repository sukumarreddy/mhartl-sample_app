class Micropost < ActiveRecord::Base
  
  # Listing 10.7
  #attr_accessible :content, :user_id
  attr_accessible :content

  # Listing 10.10
  belongs_to :user

  # Listing 10.4
  validates :user_id, presence: true

  # Listing 10.18
  validates :content, presence: true, length: { maximum: 140 }

  # Listing 10.14
  default_scope order: 'microposts.created_at DESC'

  # Listing 11.43 "a first cut"
  def Micropost.from_users_followed_by(user)
    followed_user_ids = user.followed_user_ids
    where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  end
  
end
