namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Bob Cat",
                 email: "bob-cat@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "foobar"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)

    end
    users = User.all(limit: 6)
    4.times do |n|
      log = Faker::Lorem.word
      t = "test"
      uid = "toto#{t}#{n}"
      tok = Faker::Lorem.characters(27)
      users.each do |user|
        user.accounts.create!(login: log, provider: t, token: tok, uid: uid)
      end
    end

    4.times do |n|
      log = Faker::Lorem.word
      t = "debug"
      uid = "toto#{t}#{n}"
      tok = Faker::Lorem.characters(27)
      users.each do |user|
        user.accounts.create!(login: log, provider: t, token: tok, uid: uid)
      end
    end
  end
end