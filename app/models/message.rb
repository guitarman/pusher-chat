class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user, :foreign_key => 'created_by'
end