class Api::V1::MerchantsCouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ArgumentError, with: :too_many_coupons
  def index
    coupons = Coupon.where(merchant_id: params[:merchant_id])
    options = { meta: { count: coupons.count } }
    render json: CouponSerializer.new(coupons, options)
  end


  def show
    coupon = Coupon.find(params[:id])
    invoices = Invoice.where(coupon_id: params[:id])
    options = { meta: { usage_count: invoices.count } }
    render json: CouponSerializer.new(coupon, options) 
  end

  def create
    if (Merchant.can_create_coupon?(params[:merchant_id]))
      coupon = Coupon.create!(coupon_params)
      render json: CouponSerializer.new(coupon), status: :created
    else
      raise ArgumentError, "You already have 5 active coupons."
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :description, :percent_off, :dollar_off, :status, :code, :merchant_id)
  end

  def too_many_coupons(exception)
    render json: ErrorSerializer.format_error(exception, 403), status: :forbidden
  end
end