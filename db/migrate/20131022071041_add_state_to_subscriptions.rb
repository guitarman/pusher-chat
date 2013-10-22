class AddStateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :state, :string, :null => false, :default => "offline"
  end
end
