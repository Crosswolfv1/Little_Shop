# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

merchant1 = Merchant.create(name: "Merchant One")
merchant2 = Merchant.create(name: "Merchant Two")
merchant3 = Merchant.create(name: "Merchant Three")
coupons_attributes = [
  { 
    name: "10% Off Winter Sale", 
    description: "Get 10% off on all winter clothing.", 
    percent_off: 10, 
    dollar_off: nil, 
    merchant_id: merchant1.id
  },
  { 
    name: "Flat $5 Off Your Purchase", 
    description: "Save $5 on your total purchase of $25 or more.", 
    percent_off: nil, 
    dollar_off: 5, 
    merchant_id: merchant2.id
  },
  { 
    name: "20% Off Storewide", 
    description: "Enjoy 20% off on everything in-store!", 
    percent_off: 20, 
    dollar_off: nil, 
    merchant_id: merchant3.id
  },
  { 
    name: "Free Shipping on Orders over $50", 
    description: "Get free shipping when your order exceeds $50.", 
    percent_off: nil, 
    dollar_off: nil, 
    merchant_id: merchant1.id
  },
  { 
    name: "10% Off First Order", 
    description: "Get 10% off your first purchase.", 
    percent_off: 10, 
    dollar_off: nil, 
    merchant_id: merchant2.id
  }
]

coupons_attributes.each do |coupon_attr|
  Coupon.find_or_create_by!(coupon_attr)
end