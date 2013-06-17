FactoryGirl.define do
  factory :user do
    name 'Brian Gates'
    email 'gates@example.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
