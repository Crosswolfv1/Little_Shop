class Customer < ApplicationRecord
  has_many :invoices

  def self.customersForMerchant(merchant)
    Customer.joins(:invoices).where("merchant_id = ?", merchant).uniq
  end
end