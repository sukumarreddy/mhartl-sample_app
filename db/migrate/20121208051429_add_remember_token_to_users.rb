class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    # Listing 8.16
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
  end
end
