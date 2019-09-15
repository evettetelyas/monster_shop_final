class Address < ApplicationRecord
    belongs_to :user
    has_many :orders

    validates_presence_of :nickname, :name, :address, :city, :state, :zip

    def has_no_shipped_orders?
        orders.where(status: "shipped").empty?
    end

    def has_pending_orders?
        return true unless orders.empty?
    end
end