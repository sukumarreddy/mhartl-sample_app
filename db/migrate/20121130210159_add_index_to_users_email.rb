class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	# Listing 6.22 - don't forget to run "bundle exec rake db:migrate"!
  	# unfortunately there's no way to test 'The Caveat'...is there?
  	add_index :users, :email, unique: true
  end
end
