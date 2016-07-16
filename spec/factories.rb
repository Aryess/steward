FactoryGirl.define do
  factory :user do
    name      "Alfred"
    sequence(:email) { |n| "person_#{n}@example.com"}
    password  "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

  end

  factory :account do
    sequence(:login) { |n| "acc_#{n}"}
    provider "test"
    token "bla"
    jsondump "{bla}"
    sequence(:uid) { |n| "toto#{n}"}
    user
  end
end