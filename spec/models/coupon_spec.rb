require 'rails_helper'

RSpec.describe Coupon, type: :model do

  before(:each) do
    @merchant1 = Merchant.create(
      name: "Susan"
    )

    @merchant2 = Merchant.create(
      name: "Steve"
    )

    @merchant3 = Merchant.create(
      name: "Mia"
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

    @coupon8 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 100,
      status: "active",
      code: "100foridk",
      merchant_id: @merchant3.id
    )

    @coupon9 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 80,
      dollar_off: nil,
      status: "inactive",
      code: "80formateys",
      merchant_id: @merchant3.id
    )

    @coupon10 = Coupon.create(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.promotion_code,
      percent_off: 90,
      dollar_off: nil,
      status: "active",
      code: "90forstuff",
      merchant_id: @merchant3.id
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


  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:percent_off || :flat_value ) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe "class methods" do
    it "can filter by status" do
      params = {status: "active"}
      coupons_filtered = Coupon.filter_coupons(Coupon.all, params)
      expect(coupons_filtered.count).to eq(9)
      expect(coupons_filtered.include?(@coupon9)).to eq(false)

      params = {status: "inactive"}
      coupons_filtered = Coupon.filter_coupons(Coupon.all, params)
      expect(coupons_filtered.count).to eq(1)
      expect(coupons_filtered.include?(@coupon1)).to eq(false)
    end

    it "edgecases for filtering" do
      params = {}
      coupons_filtered = Coupon.filter_coupons(Coupon.all, params)
      expect(coupons_filtered.count).to eq(10)

    end
  end
end