class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoiceItems

  validates_presence_of :status, :presence => true

  def self.find_by_status(input)
    where(status: input)
  end
end