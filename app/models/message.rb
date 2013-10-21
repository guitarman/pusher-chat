class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :sender, :foreign_key => 'created_by', :class_name => "User"

  has_many :message_views
  has_many :users, :through => :message_views
end