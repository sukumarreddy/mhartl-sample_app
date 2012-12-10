class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps # adds magic created_at and updated_at columns
    end

    # Listing 10.1 - expect to retrieve all of a user's posts in reverse order of creation
    add_index :microposts, [:user_id, :created_at]

  end
end
