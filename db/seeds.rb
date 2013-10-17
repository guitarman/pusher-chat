users = ["George", "Michael", "Peter", "John", "Jon", "Ann", "Jane", "Kyle", "James", "Robert", "Joe", "Ross", "Rachel"]

users.each do |user|
  User.find_or_create_by(name: user)
end

