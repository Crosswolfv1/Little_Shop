class Merchant < ApplicationRecord
  validates :name, :presence => true
  has_many :invoices, dependent: :destroy
  has_many :coupons, dependent: :destroy
  has_many :items, dependent: :destroy

  def self.sort_by_age
    order('created_at asc')
  end

  def self.item_status(status)
    joins(:invoices).where(invoices: { status: status }).distinct
  end

  def self.filter_merchants(scope, params)
    if params[:name]
      scope = scope.where("name ILIKE ?", "%#{params[:name]}%").order(:name).limit(1)
      return scope.first || {}
    end

    scope = scope.item_status(params[:status]) if params[:status]
    scope = scope.sort_by_age if params[:sorted] == "age"
    
    scope.empty? ? {} : scope.to_a
  end
end