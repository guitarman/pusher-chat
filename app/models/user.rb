class User < ActiveRecord::Base
  has_many :messages, :foreign_key => 'created_by'

  def self.current(user_id)
    User.find_by id: user_id
  end
end