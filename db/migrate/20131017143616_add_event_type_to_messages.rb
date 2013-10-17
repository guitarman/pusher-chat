class AddEventTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :event_type, :string, :null => false
  end
end
