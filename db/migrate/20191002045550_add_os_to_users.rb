class AddOsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :os, :string
  end
end
