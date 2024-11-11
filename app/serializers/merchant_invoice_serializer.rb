class MerchantInvoiceSerializer
    include JSONAPI::Serializer
    set_id :id
    set_type :invoice
    attributes :customer_id, :merchant_id, :status, :coupon_id 

    attribute :discounted_total do |invoice|
        merchant = invoice.merchant
        Invoice.calculate_discounted_total(invoice.id, merchant.id)
    end
end