class CouponSerializer
  include JSONAPI::Serializer
  set_id :id
  set_type :coupon
  attributes :name, :description, :percent_off, :dollar_off, :status, :code, :merchant_id
end