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
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 25,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon2 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 60,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon3 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 20,
      merchant_id: @merchant1.id
    )

    @coupon4 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 10,
      dollar_off: nil,
      merchant_id: @merchant2.id
    )

    @coupon5 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 5,
      merchant_id: @merchant2.id
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
    
      expect(coupons[:data].count).to eq(5)
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
      binding.pry

      
    end

    it "can find one coupon by ID" do

    end

    it "can't find a coupon by invalid ID (SAD)" do

    end

    it "can create a coupon with valid parameters" do

    end

    describe "can handle extra or invalid parameters" do
      it "can handle extra params and still create (SADISH)" do

      end

      it "can't create with missing params (SAD)" do

      end
    end

    it "can delete by ID" do

    end

    it "can't delete by incorrect/missing ID" do

    end

    it "can update by ID" do

    end

    it "cant update by ID (SAD)" do

    end
  end
end