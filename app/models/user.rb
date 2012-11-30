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

  # Listing 6.9 - temporarily commented out in Listings 6.10-11 for "reverse TDD" or something
  validates :name, presence: true

  # Listing 6.13
  validates :email, presence: true
end
