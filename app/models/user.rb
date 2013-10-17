class User < ActiveRecord::Base
  def self.current(user_id)
    User.find_by id: user_id
  end
end