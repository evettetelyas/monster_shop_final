FactoryBot.define do
  factory :user do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:email) {|x| "email #{x}"}
    sequence(:password) {|x| "password#{x}"}
    role { 1 }
    association :merchant, factory: :merchant
  end
end
