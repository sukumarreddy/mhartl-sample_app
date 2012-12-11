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
  # Returns microposts from the users being followed by the given user.
  def Micropost.from_users_followed_by(user)
    
    # Listing 11.45 - "formidable combination of Rails, Ruby, and SQL"
    #followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"    # SQL subselect, which is more efficient? (and lower-level...)
    ## Listing 11.44 - preparing syntax for SQL "subselect" (so far NO change)
    ##where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    #where("user_id IN (:followed_user_ids) OR user_id = :user_id",
    #      followed_user_ids: followed_user_ids, user_id: user)
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id) # n.b. raw SQL can be interpolated; need not be escaped. way to double-down on SQL...
  end

end
