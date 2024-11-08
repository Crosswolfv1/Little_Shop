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
      percent_off: 25,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon2 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: 60,
      dollar_off: nil,
      merchant_id: @merchant1.id
    )

    @coupon3 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: nil,
      dollar_off: 20,
      merchant_id: @merchant1.id
    )

    @coupon4 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
      percent_off: 10,
      dollar_off: nil,
      merchant_id: @merchant2.id
    )

    @coupon5 = Coupon.create(
      name: Faker::Commerce.product_name,
      code: Faker::Commerce.promotion_code,
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

    end

    it "can find all but is empty (SAD)" do
      
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