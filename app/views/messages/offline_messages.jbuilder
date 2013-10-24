json.array!(@offline_messages) do |message|
  json.id message.id
  json.body message.body
  json.sender_name message.sender.name
  json.sender_id message.sender.id
  json.time message.created_at.strftime("%H:%M:%S")
  json.channel_name message.channel_name
  json.event_type message.event_type
end





