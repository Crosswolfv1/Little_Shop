class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoice

  validates_presence_of :name, :presence => true
  validates_presence_of :description, :presence => true
  validates_presence_of :percent_off, unless: -> { dollar_off.present? }
  validates_presence_of :dollar_off, unless: -> { percent_off.present? }
  validates_presence_of :code, :presence => true
  validates_presence_of :status, :presence => true
  validates_presence_of :merchant_id, :presence => true

  def self.filter_coupons(scope, params)
    filter = params[:status]
    if params[:status].present?
      scope.where("status = ?", "#{filter}")
    else 
      scope
    end
  end
end

