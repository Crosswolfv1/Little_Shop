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
      code: Faker::Commerce.promotion_code,
      percent_off: 50,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon2 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: 30,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon3 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: 25,
      dollar_off: nil,
      merchant_id: @merchant2.id
    )

    @coupon4 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 5,
      merchant_id: @merchant1.id
    )

    @coupon5 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 2,
      merchant_id: @merchant2.id
    )
  end

  it 'can get all coupons for a specified merchant' do
    get '/merchants?sorted=age'
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants[:data][0][:attributes][:name]).to eq("Little Shop of Horrors")
    expect(merchants[:data][1][:attributes][:name]).to eq("Large Shop of Wonders")
    expect(merchants[:data][2][:attributes][:name]).to eq("Wizard's Chest")
  end

end