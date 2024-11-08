class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :percent_off, :dollar_off, :merchant_id
end