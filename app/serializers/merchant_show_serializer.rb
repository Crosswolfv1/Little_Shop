class MerchantShowSerializer
	include JSONAPI::Serializer
	set_id :id
	set_type :merchant
	attributes :name

	attribute :coupon_count do |merchant|
		all_coupons = Coupon.where(merchant_id: merchant.id)
		all_coupons.count
	end

	attribute :invoice_coupon_count do |merchant|
		all_coupons = Coupon.where(merchant_id: merchant.id)
		Invoice.where(coupon_id: all_coupons.pluck(:id)).count
	end
end