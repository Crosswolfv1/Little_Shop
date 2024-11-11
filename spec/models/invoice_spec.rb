require 'rails_helper'

RSpec.describe Invoice do
  before(:all) do
    @merchant1 = Merchant.create!(name: "Merchant One")
    @merchant2 = Merchant.create!(name: "Merchant Two")

    @customer = Customer.create!(first_name: "Steven", last_name: "Ross")

    @coupon1 = Coupon.create!(name: "10% Off Winter Sale", description: "Get 10% off on all winter clothing.", percent_off: 10, dollar_off: nil, status: "active", code: "10degrees", merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(name: "Flat $5 Off Your Purchase", description: "Save $5 on your total purchase of $25 or more.", percent_off: nil, dollar_off: 5, status: "active", code: "5altrive", merchant_id: @merchant2.id)

    @item1 = Item.create!(name: "apple", description: "is an apple", unit_price: 0.50, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "cherry", description: "is a cherry", unit_price: 1.50, merchant_id: @merchant2.id)

    @invoice1 = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant1.id, coupon_id: @coupon1.id, status: 'shipped')
    @invoice2 = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant2.id, coupon_id: @coupon2.id, status: 'shipped')

    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: @item1.unit_price)
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 3, unit_price: @item2.unit_price)
  end

  after(:all) do
    InvoiceItem.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Coupon.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
  end

  describe 'class methods' do
    it 'finds all invoices for a particular merchant by status' do
      shipped_invoices = Invoice.find_by_status("shipped")
      expect(shipped_invoices.length).to eq(2)
      expect(shipped_invoices).to include(@invoice1, @invoice2)
    end

    it 'can apply a percentage-off coupon to the invoice' do
      total_before_discount = Invoice.calculate_discounted_total(@invoice1.id, @invoice1.merchant_id)
      expected_total = (@item1.unit_price * @invoice_item1.quantity) * (1 - @coupon1.percent_off / 100.0)
      expect(total_before_discount).to eq(expected_total)
    end
    
    it 'can apply a dollar-off coupon to the invoice' do
      total_before_discount = Invoice.calculate_discounted_total(@invoice2.id, @invoice2.merchant_id)
      expected_total = [(@item2.unit_price * @invoice_item2.quantity) - @coupon2.dollar_off, 0].max
      expect(total_before_discount).to eq(expected_total)
    end

    it 'will apply the coupon but the total will not go below $0 (dollar-off)' do
      total_with_discount = Invoice.calculate_discounted_total(@invoice2.id, @invoice2.merchant_id)
      
      expected_total = (@item2.unit_price * @invoice_item2.quantity) - @coupon2.dollar_off
      expected_total = expected_total < 0 ? 0 : expected_total
      
      expect(total_with_discount).to eq(expected_total)
    end
  end
end


