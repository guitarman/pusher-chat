class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :sender, :foreign_key => 'created_by'
end