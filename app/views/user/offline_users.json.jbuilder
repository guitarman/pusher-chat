json.array!(@offline_users) do |json, user|
  json.id user.id
  json.info user, :name
end
