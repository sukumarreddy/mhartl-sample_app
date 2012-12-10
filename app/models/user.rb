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

class User < ActiveRecord::Base
  attr_accessible :email, :name
  
  # Listing 6.30 
  attr_accessible :password, :password_confirmation

  # Exercise 9.1 testing - uncommenting this should cause new test to fail
  #attr_accessible :admin

  # Listing 6.30
  has_secure_password

  # Listing 10.11
  has_many :microposts

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

  private

  # Listing 8.18
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
