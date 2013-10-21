class Channel < ActiveRecord::Base
  has_many :messages

  has_many :subscriptions
  has_many :users, :through => :subscriptions
end