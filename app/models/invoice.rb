class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items

  validates_presence_of :status, :presence => true

  def self.find_by_status(input)
    where(status: input)
  end

  def self.calculate_discounted_total(invoice_id, merchant_id)
    invoice = Invoice.find(invoice_id)
    merchant_items = invoice.invoice_items.joins(:item).where(items: { merchant_id: merchant_id })
    total = merchant_items.sum { |invoice_item| invoice_item.unit_price * invoice_item.quantity }
    coupon = invoice.coupon
    if coupon
      if coupon.dollar_off
        total -= coupon.dollar_off
        total = 0 if total < 0
      elsif coupon.percent_off

        discount = total * (coupon.percent_off / 100.0)
        total -= discount
      end
    end
  
    total
  end
end