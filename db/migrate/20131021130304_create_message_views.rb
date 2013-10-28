class CreateMessageViews < ActiveRecord::Migration
  def change
    create_table :message_views do |t|
      t.references :user
      t.references :message

      t.boolean :viewed, :default => false, :null => false
    end
  end
end
