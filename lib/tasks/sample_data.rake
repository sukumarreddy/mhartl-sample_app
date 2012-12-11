# Listing 9.30: "This is a bit advanced, so don't worry too much about the details."
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do # ensure Rake task has access to local Rails environment, including User model

    # Listing 11.17 refactored this mess into subroutines
    make_users
    make_microposts
    make_relationships
  end
end



def make_users
  # Listing 9.41 make first user admin
  #User.create!(name: "Example User", # unlike create(), create!() will raise exception on failure. easier for debugging...
  admin = User.create!(
               name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  admin.toggle!(:admin) # Listing 9.41; not attr_accessible, so can't be assigned by mass-assignment.

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end # make_users()



def make_microposts

  # Listing 10.23 Adding microposts to the sample data. Go run "db:reset, db:populate, db:test:prepare"
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end

end



# Listing 11.17
def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end


