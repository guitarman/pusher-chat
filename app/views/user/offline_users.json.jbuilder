json.array!(@offline_users) do |user|
  json.id user.id
  json.info user, :name
end
