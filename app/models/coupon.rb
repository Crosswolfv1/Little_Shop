class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, optional: true
  
end
