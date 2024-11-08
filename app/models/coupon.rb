class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice
end