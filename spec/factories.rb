# Listing 7.8
FactoryGirl.define do
  factory :user do
    # Listing 9.32 - Factory Girl sequence
    #name     "Michael Hartl"
    #email    "michael@example.com"
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    
    password "foobar"
    password_confirmation "foobar"

    # Listing 9.43 - requires restarting "bundle exec guard"?
    factory :admin do
      admin true
    end
  end
end
