# Listing 9.30: "This is a bit advanced, so don't worry too much about the details."
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do # ensure Rake task has access to local Rails environment, including User model
    User.create!(name: "Example User", # unlike create(), create!() will raise exception on failure. easier for debugging...
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end