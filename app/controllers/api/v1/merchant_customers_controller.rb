class Api::V1::MerchantCustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    merchant = Merchant.find(params[:id]).id
    customers = Customer.joins(:invoices).where("merchant_id = ?", merchant).uniq
    render json: CustomerSerializer.new(customers)
  end

  private

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end
end