class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :sender, :foreign_key => 'created_by', :class_name => "User"

  has_many :message_views
  has_many :users, :through => :message_views

  def read_message(user_id)
    message_view = message_views.find_by(user_id: user_id)
    message_view.update_attributes(viewed: true) if message_view
  end

  def self.unread_messages
    includes(:message_views)
  end
end