class Coupon < ApplicationRecord
    validates_presence_of :status, :merchant_id
    validates :name, presence: true, uniqueness: true

    enum status: { active: 0, inactive: 1 }

    belongs_to :merchant

    def percent_off
        if self.percent == 0
            return "--"
        else
            "#{self.percent}%"
        end
    end

    def amount_off
        if self.amount == 0
            return "--"
        else
            "$#{self.amount}.00"
        end
    end

    def num_redemptions
        Order.where(coupon_code: self.name).count
    end

    def change_status
        if self.status == "active"
            self.update(status: 1)
            self.save
        elsif self.status == "inactive"
            self.update(status: 0)
            self.save
        end
    end

    def has_order_items?(order)
        !order.items.where(merchant_id: self.merchant_id).empty?
    end
end