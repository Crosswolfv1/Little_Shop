class MerchantIndexSerializer
	include JSONAPI::Serializer
	set_id :id
	set_type :merchant
	attributes :name

	attribute :item_count do |merchant|
		merchant.items.count
	end

	attribute :coupon_count do |merchant|
		coupons = Coupon.where(merchant_id: merchant.id)
		if coupons.empty?
			0
		end
	end

	attribute :invoice_coupon_count do |merchant|
		all_coupons = Coupon.where(merchant_id: merchant.id)
		Invoice.where(coupon_id: all_coupons.pluck(:id)).count
	end
end