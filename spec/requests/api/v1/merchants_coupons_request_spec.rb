require 'rails_helper'

describe "items_merchants" do
  before(:each) do
    @merchant1 = Merchant.create(
      name: "Susan"
    )

    @merchant2 = Merchant.create(
      name: "Steve"
    )

    @coupon1 = Coupon.create(
      name: "25% off your purchase",
      description: Faker::Commerce.promotion_code,
      percent_off: 25,
      dollar_off: nil,
      status: "active",
      code: "25jointhehive",
      merchant_id: @merchant1.id
    )

    @coupon2 = Coupon.create(
      name: "60% off the store",
      description: Faker::Commerce.promotion_code,
      percent_off: 60,
      dollar_off: nil,
      status: "active",
      code: "60formisty",
      merchant_id: @merchant1.id
    )

    @coupon3 = Coupon.create(
      name: "$20 off from tacos",
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 20,
      status: "active",
      code: "20deephoney",
      merchant_id: @merchant1.id
    )

    @coupon4 = Coupon.create(
      name: "10% on Baby Supplies",
      description: Faker::Commerce.promotion_code,
      percent_off: 10,
      dollar_off: nil,
      status: "active",
      code: "10forme",
      merchant_id: @merchant2.id
    )

    @coupon5 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 5,
      status: "active",
      code: "5alive",
      merchant_id: @merchant2.id
    )
    @coupon6 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 35,
      dollar_off: nil,
      status: "active",
      code: "35cantdrive",
      merchant_id: @merchant1.id
    )
    @coupon7 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 200,
      status: "active",
      code: "200formildred",
      merchant_id: @merchant1.id
    )

    @bob = Customer.create!(
      first_name: "Bob",
      last_name: "Tucker"
    )

    @kathy = Customer.create!(
      first_name: "Kathy",
      last_name: "Tucker"
    )

    @invoice1 = Invoice.create!(
      customer_id: @bob.id,
      merchant_id: @merchant1.id,
      status: "shipped",
      coupon_id: @coupon1.id
    )

    @invoice2 = Invoice.create!(
      customer_id: @kathy.id,
      merchant_id: @merchant1.id,
      status: "shipped",
      coupon_id: @coupon1.id
    )

    @invoice2 = Invoice.create!(
      customer_id: @kathy.id,
      merchant_id: @merchant1.id,
      status: "shipped",
      coupon_id: @coupon1.id
    )

    @invoice2 = Invoice.create!(
      customer_id: @kathy.id,
      merchant_id: @merchant1.id,
      status: "shipped",
      coupon_id: @coupon1.id
    )

    @invoice2 = Invoice.create!(
      customer_id: @kathy.id,
      merchant_id: @merchant1.id,
      status: "shipped",
      coupon_id: @coupon2.id
    )

    @invoice2 = Invoice.create!(
      customer_id: @kathy.id,
      merchant_id: @merchant1.id,
      status: "packaged",
      coupon_id: @coupon2.id
    )
  end

  after(:all) do
    Invoice.delete_all
    Merchant.delete_all
    Coupon.delete_all
  end

  describe "crud" do
    it "can get all coupons by merchant id" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons"
      expect(response).to be_successful

      merchants_coupons = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_coupons[:data].count).to eq(5)
      expect(merchants_coupons[:data][0][:id]).to eq(@coupon1.id.to_s)
      expect(merchants_coupons[:data][1][:id]).to eq(@coupon2.id.to_s)
      expect(merchants_coupons[:data].map { |coupon| coupon[:id] }).not_to include(@coupon4.id.to_s)
    end

    it "can get a single coupon by merchant and coupon id" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"
      expect(response).to be_successful

      merchants_coupons = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_coupons[:meta]).to have_key(:usage_count)
      expect(merchants_coupons[:meta][:usage_count]).to equal(4)

      expect(merchants_coupons[:data][:id]).to eq(@coupon1.id.to_s)
    end

    describe "can create merchant coupons" do
      it "can create a new coupon" do
        get "/api/v1/merchants/#{@merchant2.id}/coupons"
        merchants_coupons = JSON.parse(response.body, symbolize_names: true)
        expect(merchants_coupons[:data].count).to eq(2)


        params = {
          name: Faker::Commerce.product_name,
          description: Faker::Commerce.promotion_code,
          percent_off: 2000,
          dollar_off: nil,
          status: "active",
          code: "2kforhey",
          merchant_id: @merchant2.id
        }

        post "/api/v1/merchants/#{@merchant2.id}/coupons", params: {coupon: params}

        expect(response).to be_successful
        coupon_created = JSON.parse(response.body, symbolize_names: true)
        coupon = coupon_created[:data]
        expect(coupon_created[:data]).to have_key(:id)
        expect(coupon_created[:data][:id]).to be_an(String)
        get "/api/v1/merchants/#{@merchant2.id}/coupons"
        all_coupons = JSON.parse(response.body, symbolize_names: true)

        expect(all_coupons[:data]).to include(coupon)
      end

      it "Will fail to create a new coupon if merchant has 5 ACTIVE coupons" do
        get "/api/v1/merchants/#{@merchant1.id}/coupons"
        merchants_coupons = JSON.parse(response.body, symbolize_names: true)
        expect(merchants_coupons[:data].count).to eq(5)


        params = {
          name: Faker::Commerce.product_name,
          description: Faker::Commerce.promotion_code,
          percent_off: 2,
          dollar_off: nil,
          status: "active",
          code: "2foryou",
          merchant_id: @merchant1.id
        }

        post "/api/v1/merchants/#{@merchant1.id}/coupons", params: {coupon: params}
        expect(response).not_to be_successful
        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_an(Array)
        expect(data[:message]).to eq("Your query could not be completed")
        expect(data[:errors][0][:title]).to include("You already have 5 active coupons")  
      end

      it "will fail to create a new coupon if code is not unique" do
        get "/api/v1/merchants/#{@merchant2.id}/coupons"
        merchants_coupons = JSON.parse(response.body, symbolize_names: true)
        expect(merchants_coupons[:data].count).to eq(2)


        params = {
          name: Faker::Commerce.product_name,
          description: Faker::Commerce.promotion_code,
          percent_off: 2000,
          dollar_off: nil,
          status: "active",
          code: "10forme",
          merchant_id: @merchant2.id
        }

        post "/api/v1/merchants/#{@merchant2.id}/coupons", params: {coupon: params}
        expect(response).not_to be_successful
        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_an(Array)
        expect(data[:message]).to eq("Your query could not be completed")
        expect(data[:errors][0][:title]).to include("This coupon code already exists.")  
      end
    end

    it "can update a coupon to be active/inactive" do
      get "/api/v1/merchants/#{@merchant2.id}/coupons/#{@coupon4.id}"
      merchants_coupon = JSON.parse(response.body, symbolize_names: true)
      expect(merchants_coupon[:data][:attributes][:status]).to eq("active")

      params = {
        status: "inactive",
      }

      patch "/api/v1/merchants/#{@merchant2.id}/coupons/#{@coupon4.id}", params: {coupon: params}
      expect(response).to be_successful
      merchants_inactive_coupon = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_inactive_coupon[:data][:attributes][:status]).to eq("inactive")

      params = {
        status: "active",
      }
      patch "/api/v1/merchants/#{@merchant2.id}/coupons/#{@coupon4.id}", params: {coupon: params}
      expect(response).to be_successful
      merchants_active_coupon = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_active_coupon[:data][:attributes][:status]).to eq("active")
    end

    it "SAD cant deactivate a coupon if an invoice is pending" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon2.id}"
      merchants_coupon = JSON.parse(response.body, symbolize_names: true)
      expect(merchants_coupon[:data][:attributes][:status]).to eq("active")

      params = {
        status: "inactive",
      }

      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon2.id}", params: {coupon: params}
      expect(response).not_to be_successful
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:message]).to eq("Your query could not be completed")
      expect(data[:errors][0][:title]).to include("This coupon is in use")
    end
  end
end