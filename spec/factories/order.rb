FactoryBot.define do
  factory :order do
    sequence(:created_at) {|x| "Created at: #{x}"}
    sequence(:updated_at) {|x| "Last Update: #{x}"}
    address
  end
end
