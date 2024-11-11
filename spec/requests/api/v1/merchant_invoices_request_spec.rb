require 'rails_helper'

describe "MerchantInvoices" do
  before :each do
    @merchant1 = Merchant.create!(name: "Little Shop of Horrors")
    @merchant2 = Merchant.create!(name: "Large Shop of Wonders")
    @customer = Customer.create!(first_name: "Bob", last_name: "Tucker")

    @coupon1 = Coupon.create!(name: "10% Off Winter Sale", description: "Get 10% off on all winter clothing.", percent_off: 10, dollar_off: nil, status: "active", code: "10degrees", merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(name: "Flat $5 Off Your Purchase", description: "Save $5 on your total purchase of $25 or more.", percent_off: nil, dollar_off: 5, status: "active", code: "5off", merchant_id: @merchant1.id)

    @item1 = Item.create!(name: "apple", description: "is an apple", unit_price: 1.0, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "banana", description: "is a banana", unit_price: 2.0, merchant_id: @merchant1.id)

    @invoice1 = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant1.id, status: "shipped", coupon: @coupon1)
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: @item1.unit_price)

    @invoice2 = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant1.id, status: "shipped", coupon: @coupon2)
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

  it 'returns all invoices for a given merchant' do
    merchant = Merchant.create!(name: "Test Merchant")
    bob = Customer.create!(first_name: "Bob", last_name: "Tucker")
    kathy = Customer.create!(first_name: "Kathy", last_name: "Tucker")
    invoice1 = Invoice.create!(customer_id: bob.id, merchant_id: merchant.id, status: "shipped")
    invoice2 = Invoice.create!(customer_id: kathy.id, merchant_id: merchant.id, status: "shipped")

    get "/api/v1/merchants/#{merchant.id}/invoices?status=shipped"
    
    expect(response).to be_successful

    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:data].count).to eq(2)
  end

  it 'gets all merchants with returned items' do
    bob = Customer.create!(first_name: "Bob", last_name: "Tucker")
    kathy = Customer.create!(first_name: "Kathy", last_name: "Tucker")
    invoice1 = Invoice.create!(customer_id: bob.id, merchant_id: @merchant1.id, status: "returned")
    invoice2 = Invoice.create!(customer_id: kathy.id, merchant_id: @merchant2.id, status: "shipped")

    get "/api/v1/merchants?status=returned"

    expect(response).to be_successful

    response_data = JSON.parse(response.body, symbolize_names: true)
    
    expect(response_data[:data].count).to eq(1)
  end

  describe 'sad paths' do 
    it 'has a sad path for not finding a status' do
      get "/api/v1/merchants/#{@merchant1.id}/invoices", params: { status: "no_status" }

      expect(response).to have_http_status(:not_found)

      response_data = JSON.parse(response.body, symbolize_names: true)
    
      expect(response_data[:message]).to eq("Your query could not be completed")
      expect(response_data[:errors][0][:title]).to eq("No invoices found with status no_status")
    end

    it 'has a sad path for when the merchant id is not found' do
      get "/api/v1/merchants/99999999/invoices"

      expect(response).to have_http_status(:not_found)
      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data[:message]).to eq("Your query could not be completed")
      expect(response_data[:errors]).to be_an(Array)
      expect(response_data[:errors][0][:status]).to eq("404")
      expect(response_data[:errors][0][:title]).to include("Couldn't find Merchant")
    end
  end

  it 'returns all invoices for a given merchant with the discounted total' do
    get "/api/v1/merchants/#{@merchant1.id}/invoices?status=shipped"
    
    expect(response).to be_successful
  
    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:data].count).to eq(2)
    expect(response_data[:data][0][:id].to_i).to eq(@invoice1.id)
    expect(response_data[:data][0][:attributes][:discounted_total]).to eq(1.8) 
  end
end