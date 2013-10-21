class AddUserToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :created_by, :integer
  end
end
