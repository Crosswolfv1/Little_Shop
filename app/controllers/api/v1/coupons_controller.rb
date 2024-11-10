class Api::V1::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ArgumentError, with: :invalid_parameters


  def index
    coupons = Coupon.all
    options = { meta: { count: coupons.count } }
    render json: CouponSerializer.new(coupons, options)
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update!(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def create
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon), status: :created
  end

  def destroy
    render json: Coupon.delete(params[:id]), status: :no_content
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :description, :percent_off, :dollar_off, :status, :code, :merchant_id)
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end
end