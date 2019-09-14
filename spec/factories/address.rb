FactoryBot.define do
    factory :address do
      sequence(:name) {|x| "Name #{x}"}
      sequence(:address) {|x| "Address #{x}"}
      sequence(:city) {|x| "City #{x}"}
      sequence(:state) {|x| "State #{x}"}
      zip {rand(10000..99999)}
      sequence(:created_at) {|x| "Created at: #{x}"}
      sequence(:updated_at) {|x| "Last Update: #{x}"}
      user
    end
  end
  