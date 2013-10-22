class User < ActiveRecord::Base
  has_many :sent_messages, :foreign_key => 'created_by', :class_name => "Message"

  has_many :message_views
  has_many :messages, :through => :message_views

  has_many :subscriptions
  has_many :channels, :through => :subscriptions

  def self.current(user_id)
    User.find_by id: user_id
  end

  def self.offline_users(online_user_ids)
    where.not(id: online_user_ids)
  end
end