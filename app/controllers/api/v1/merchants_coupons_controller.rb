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
    can_create_coupon?(params[:merchant_id], params[:coupon][:code])
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update
    in_use?(params[:id])
    coupon = Coupon.find(params[:id])
    coupon.update!(coupon_params)
    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :description, :percent_off, :dollar_off, :status, :code, :merchant_id)
  end

  def can_create_coupon?(merchant_id, code)
    coupons_count(merchant_id) && coupons_unique?(merchant_id, code) 
  end

  def coupons_count(merchant_id)
    if (Coupon.where(merchant_id: merchant_id, status: 'active').count >= 5)
      raise ArgumentError, "You already have 5 active coupons."
    end
    true
  end

  def coupons_unique?(merchant_id, code)
    if (Coupon.where(merchant_id: merchant_id, code: code).exists?)
      raise ArgumentError, "This coupon code already exists."
    end
    true
  end

  def too_many_coupons(exception)
    render json: ErrorSerializer.format_error(exception, 403), status: :forbidden
  end

  def in_use?(coupon_id)
    if (Invoice.where(coupon_id: coupon_id).where.not(status: "shipped").exists?)
      raise ArgumentError, "This coupon is in use"
    end
    true
  end
end