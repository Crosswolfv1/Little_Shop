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

  private

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(exception, 400), status: :bad_request
  end
end