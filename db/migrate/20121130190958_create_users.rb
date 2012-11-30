class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      # Listing 6.2: auto-generated code to create magic columns created_at and updated_at
      t.timestamps
    end
  end
end
