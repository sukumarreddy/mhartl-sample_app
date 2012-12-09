class AddAdminToUsers < ActiveRecord::Migration
  def change

    # Listing 9.40 explicitly add default: false - users should NOT be administrators by default.    
    # system default is actually "nil", but this shows intent more explicitly.
    add_column :users, :admin, :boolean, default: false

  end
end
