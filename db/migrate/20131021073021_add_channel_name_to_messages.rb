class AddChannelNameToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :channel_name, :string, :null => false
  end
end
