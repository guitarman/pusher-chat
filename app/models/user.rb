class User < ActiveRecord::Base
  has_many :sent_messages, :foreign_key => 'created_by', :class_name => "Message"

  def self.current(user_id)
    User.find_by id: user_id
  end
end