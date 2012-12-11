# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)u
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name
  
  # Listing 6.30 
  attr_accessible :password, :password_confirmation

  # Exercise 9.1 testing - uncommenting this should cause new test to fail
  #attr_accessible :admin

  # Listing 6.30
  has_secure_password

  # Listing 10.11
  # Listing 10.16 adds "dependent: :destroy"
  has_many :microposts, dependent: :destroy

  # Listing 11.4
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  # Listing 11.6 - Rails' default has_many :followed would result in weird-looking "followeds"
  has_many :followed_users, through: :relationships, source: :followed

  # Listing 11.16
  # my biggest complaint about Rails and TDD: how would you know to write this OR its test,
  # without first being really really familiar with Rails and what it can do??
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship", # otherwise Rails looks for class ReverseRelationship
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower # optional source; retained for symmetry

  # Listing 6.9 - temporarily commented out in Listings 6.10-11 for "reverse TDD" or something
  # Listing 6.15 - add length validation
  validates :name, presence: true, length: { maximum: 50 }

  # Listing 6.13
  # Listing 6.17 add regex validation
  # Listing 6.19 add uniqueness
  # Listing 6.21 case-insensitivity
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # Listing 6.30
  validates :password, length: { minimum: 6 }#, presence: true # Exercise 7.3 - presence is redundant now
  validates :password_confirmation, presence: true

  # Listing 6.23
  before_save do |user| 
  	#user.email = email.downcase 
  	self.email.downcase! # Listing 6.32 alternative (Exercise 6.2)
  end

  # Listing 8.18
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  # Listing 10.39
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id) # ensure "id" is properly escaped before SQL query (prevent SQL injection)

    # equivalently just use this line (laying foundation for Chapter 11 instead)
    # microposts
  end

  # Listing 11.12
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  def follow!(other_user) # via relationships association
    relationships.create!(followed_id: other_user.id) # equivalently, self.relationships.create!()
  end

  # Listing 11.13
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

  # Listing 8.18
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
