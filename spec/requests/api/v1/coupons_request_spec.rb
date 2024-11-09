require 'rails_helper'
describe "coupons" do
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
      status: "inactive",
      code: "60formisty",
      merchant_id: @merchant1.id
    )

    @coupon3 = Coupon.create(
      name: "$20 off from tacos",
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 20,
      status: "inactive",
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
      status: "inactive",
      code: "35cantdrive",
      merchant_id: @merchant1.id
    )
    @coupon7 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 200,
      status: "inactive",
      code: "200formildred",
      merchant_id: @merchant1.id
    )
  end

  after(:all) do
    Invoice.delete_all
    Merchant.delete_all
    Coupon.delete_all
  end

  describe "coupons crud" do
    it "can find all" do
      get '/api/v1/coupons'
      expect(response).to be_successful
      coupons = JSON.parse(response.body, symbolize_names: true)
    
      expect(coupons[:data].count).to eq(7)
      expect(coupons[:meta]).to have_key(:count)
      expect(coupons[:meta][:count]).to equal(coupons[:data].count)

      coupons[:data].each do |coupon|
        expect(coupon).to have_key(:id)
        expect(coupon[:id]).to be_an(String)

        expect(coupon[:attributes]).to have_key(:name)
        expect(coupon[:attributes][:name]).to be_a(String)

        expect(coupon[:attributes]).to have_key(:description)
        expect(coupon[:attributes][:description]).to be_a(String)

        expect(coupon[:attributes]).to have_key(:percent_off)
        expect(coupon[:attributes][:percent_off]).to be_a(Integer).or be_nil

        expect(coupon[:attributes]).to have_key(:dollar_off)
        expect(coupon[:attributes][:dollar_off]).to be_a(Integer).or be_nil

        expect(coupon[:attributes][:percent_off].nil? && coupon[:attributes][:dollar_off].nil?).to be false

        expect(coupon[:attributes]).to have_key(:status)
        expect(coupon[:attributes][:status]).to be_a(String)

        expect(coupon[:attributes]).to have_key(:merchant_id)
        expect(coupon[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it "can find all but is empty (SAD)" do
      Coupon.delete_all
      get '/api/v1/coupons'
      expect(response).to be_successful
      coupons = JSON.parse(response.body, symbolize_names: true)
    
      expect(coupons[:data].count).to eq(0)
      expect(coupons[:meta]).to have_key(:count)
      expect(coupons[:meta][:count]).to equal(coupons[:data].count)
    end

    it "can find one coupon by ID" do
      get "/api/v1/coupons/#{@coupon1.id}"
      expect(response).to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)

      expect(coupon[:data]).to have_key(:id)
      expect(coupon[:data][:id]).to be_an(String)

      expect(coupon[:data][:attributes]).to have_key(:name)
      expect(coupon[:data][:attributes][:name]).to be_a(String)

      expect(coupon[:data][:attributes]).to have_key(:description)
      expect(coupon[:data][:attributes][:description]).to be_a(String)

      expect(coupon[:data][:attributes]).to have_key(:percent_off)
      expect(coupon[:data][:attributes][:percent_off]).to be_a(Integer).or be_nil

      expect(coupon[:data][:attributes]).to have_key(:dollar_off)
      expect(coupon[:data][:attributes][:dollar_off]).to be_a(Integer).or be_nil

      expect(coupon[:data][:attributes][:percent_off].nil? && coupon[:data][:attributes][:dollar_off].nil?).to be false

      expect(coupon[:data][:attributes]).to have_key(:code)
      expect(coupon[:data][:attributes][:code]).to be_a(String)

      expect(coupon[:data][:attributes]).to have_key(:status)
      expect(coupon[:data][:attributes][:status]).to be_a(String)

      expect(coupon[:data][:attributes]).to have_key(:merchant_id)
      expect(coupon[:data][:attributes][:merchant_id]).to be_a(Integer)
    end

    it "can't find a coupon by invalid ID (SAD)" do
      get "/api/v1/coupons/200000"
      expect(response).not_to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)

    end

    it "can create a coupon with valid parameters" do
      coupon_params = {
        name: Faker::Commerce.product_name,
        description: Faker::Commerce.promotion_code,
        percent_off: nil,
        dollar_off: 300,
        status: "inactive",
        code: "300sparta",
        merchant_id: @merchant2.id
      }
      post '/api/v1/coupons', params: {coupon: coupon_params}

      expect(response).to be_successful
      coupon_created = JSON.parse(response.body, symbolize_names: true)
      coupon = coupon_created[:data]

      expect(coupon_created[:data]).to have_key(:id)
      expect(coupon_created[:data][:id]).to be_an(String)

      expect(coupon_created[:data][:attributes]).to have_key(:name)
      expect(coupon_created[:data][:attributes][:name]).to be_a(String)

      expect(coupon_created[:data][:attributes]).to have_key(:description)
      expect(coupon_created[:data][:attributes][:description]).to be_a(String)

      expect(coupon_created[:data][:attributes]).to have_key(:percent_off)
      expect(coupon_created[:data][:attributes][:percent_off]).to be_a(Integer).or be_nil

      expect(coupon_created[:data][:attributes]).to have_key(:dollar_off)
      expect(coupon_created[:data][:attributes][:dollar_off]).to be_a(Integer).or be_nil

      expect(coupon_created[:data][:attributes][:percent_off].nil? && coupon_created[:data][:attributes][:dollar_off].nil?).to be false

      expect(coupon_created[:data][:attributes]).to have_key(:code)
      expect(coupon_created[:data][:attributes][:code]).to be_a(String)

      expect(coupon_created[:data][:attributes]).to have_key(:status)
      expect(coupon_created[:data][:attributes][:status]).to be_a(String)

      expect(coupon_created[:data][:attributes]).to have_key(:merchant_id)
      expect(coupon_created[:data][:attributes][:merchant_id]).to be_a(Integer)

      get "/api/v1/coupons"
      all_coupons = JSON.parse(response.body, symbolize_names: true)

      expect(all_coupons[:data]).to include(coupon)
    end

    describe "can handle extra or invalid parameters" do
      it "can handle extra params and still create (SADISH)" do
        coupon_params = {
          name: Faker::Commerce.product_name,
          description: Faker::Commerce.promotion_code,
          percent_off: nil,
          dollar_off: 300,
          status: "inactive",
          code: "300sparta",
          merchant_id: @merchant2.id,
          pineapples: "yes"
        }
        post '/api/v1/coupons', params: {coupon: coupon_params}
  
        expect(response).to be_successful
        coupon_created = JSON.parse(response.body, symbolize_names: true)
        expect(coupon_created[:data][:attributes]).not_to have_key(:pineapples)
        expect(coupon_created[:data][:attributes][:pineapples]).to be(nil)
      end

      it "can't create with missing params (SAD)" do
        coupon_params = {
          name: Faker::Commerce.product_name,
          description: Faker::Commerce.promotion_code,
          percent_off: nil,
          dollar_off: 300,
          status: "inactive"
        }  

        post '/api/v1/coupons', params: {coupon: coupon_params}
  
        expect(response).not_to be_successful
        json_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(json_response[:errors]).to be_an(Array)
        expect(json_response[:message]).to eq("Your query could not be completed")
        expect(json_response[:errors][0]).to include("Merchant must exist")
      end
    end

    it "can delete by ID" do
      coupon_params = {
        name: Faker::Commerce.product_name,
        description: Faker::Commerce.promotion_code,
        percent_off: nil,
        dollar_off: 300,
        code: "300sparta",
        status: "inactive",
        merchant_id: @merchant2.id
      }
      post '/api/v1/coupons', params: {coupon: coupon_params}

      expect(response).to be_successful
      coupon_created = JSON.parse(response.body, symbolize_names: true)

      coupon = coupon_created[:data]
      coupon_id = coupon_created[:data][:id]

      delete "/api/v1/coupons/#{coupon_id.to_i}"
      expect(response).to be_successful

      get "/api/v1/coupons"
      all_coupons_delete = JSON.parse(response.body, symbolize_names: true)

      expect(all_coupons_delete[:data]).not_to include(coupon)
    end

    it "can update by ID" do
      updated_params = {
        name: "buy one Get one!",
        percent_off: 100
      }

      patch "/api/v1/coupons/#{@coupon2.id}", params: { coupon: updated_params }

      expect(response).to be_successful

      coupon = JSON.parse(response.body, symbolize_names: true)

      expect(coupon[:data][:attributes][:name]).to eq("buy one Get one!")
      expect(coupon[:data][:attributes][:percent_off]).to eq(100)
      expect(coupon[:data][:attributes][:merchant_id]).to eq(@coupon2.merchant_id)
    end
    
    it "can update by ID (SAD) but extra attributes " do
      updated_params = {
        name: "buy one Get one!",
        percent_off: 100,
        battlepass: "active"
      }

      patch "/api/v1/coupons/#{@coupon2.id}", params: { coupon: updated_params }

      expect(response).to be_successful

      coupon = JSON.parse(response.body, symbolize_names: true)

      expect(coupon[:data][:attributes][:name]).to eq("buy one Get one!")
      expect(coupon[:data][:attributes][:percent_off]).to eq(100)
      expect(coupon[:data][:attributes][:merchant_id]).to eq(@coupon2.merchant_id)
      expect(coupon[:data][:attributes][:battlepass]).to be(nil)
    end
  end
end