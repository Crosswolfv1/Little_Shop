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
## run in rails c
# merchant1 = Merchant.create(name: "Merchant One")
# merchant2 = Merchant.create(name: "Merchant Two")
# merchant3 = Merchant.create(name: "Merchant Three")
# coupons_attributes = [
#   { 
#     name: "20% Off Storewide", 
#     description: "Enjoy 20% off on everything in-store!", 
#     percent_off: 20, 
#     dollar_off: nil, 
#     status: "inactive",
#     code: "20forhoney",
#     merchant_id: merchant3.id
#   },
#   { 
#     name: "Free Shipping on Orders over $50", 
#     description: "Get free shipping when your order exceeds $50.", 
#     percent_off: nil, 
#     dollar_off: 50, 
#     status: "active",
#     code: "50thrifty",
#     merchant_id: merchant1.id
#   },
#   { 
#     name: "10% Off First Order", 
#     description: "Get 10% off your first purchase.", 
#     percent_off: 10, 
#     dollar_off: nil, 
#     status: "inactive",
#     code: "10forwin",
#     merchant_id: merchant2.id
#   }
# ]

# coupons_attributes.each do |coupon_attr|
#   Coupon.find_or_create_by!(coupon_attr)
# end

# coupon1 = Coupon.create(  { 
#   name: "10% Off Winter Sale", 
#   description: "Get 10% off on all winter clothing.", 
#   percent_off: 10, 
#   dollar_off: nil, 
#   status: "active",
#   code: "10degrees",
#   merchant_id: merchant1.id
# })

# coupon2 = Coupon.create(  { 
#     name: "Flat $5 Off Your Purchase", 
#     description: "Save $5 on your total purchase of $25 or more.", 
#     percent_off: nil, 
#     dollar_off: 5, 
#     status: "active",
#     code: "5altrive",
#     merchant_id: merchant2.id
# })


# customer1 = Customer.create({ first_name: 'John', last_name: 'Doe' })
# customer2 = Customer.create({ first_name: 'Jane', last_name: 'Smith' })


# invoice1 = Invoice.create({ customer_id: customer1.id, merchant_id: merchant1.id, coupon_id: coupon1.id, status: 'shipped' })
# invoice2 = Invoice.create({ customer_id: customer1.id, merchant_id: merchant1.id, coupon_id: coupon1.id, status: 'packaged' })
# invoice3 = Invoice.create(  { customer_id: customer1.id, merchant_id: merchant2.id, coupon_id: coupon2.id, status: 'returned' })
# invoice4 = Invoice.create(  { customer_id: customer2.id, merchant_id: merchant3.id, coupon_id: nil, status: 'shipped' })
# invoice5 = Invoice.create(  { customer_id: customer2.id, merchant_id: merchant3.id, coupon_id: nil, status: 'shipped' })

# item1 = Item.create({
#   name: "apple",
#   description: "is am apple",
#   unit_price: 0.50,
#   merchant_id: merchant1.id
# })

# item2 = Item.create({
#   name: "cherry",
#   description: "is am cherry",
#   unit_price: 1.50,
#   merchant_id: merchant2.id
# })

# item3 = Item.create({
#   name: "pear",
#   description: "is am pear",
#   unit_price: 0.75,
#   merchant_id: merchant1.id
# })

# item4 = Item.create({
#   name: "banana",
#   description: "is am banaa",
#   unit_price: 3.50,
#   merchant_id: merchant2.id
# })

# item5 = Item.create({
#   name: "dog",
#   description: "is dog",
#   unit_price: 350.50,
#   merchant_id: merchant3.id
# })

# item6 = Item.create({
#   name: "cat",
#   description: "is cat",
#   unit_price: 300.50,
#   merchant_id: merchant3.id
# })

# InvoiceItem.create({ invoice_id: invoice1.id, item_id: item1.id, quantity: 5, unit_price: item1.unit_price })
# InvoiceItem.create({ invoice_id: invoice1.id, item_id: item3.id, quantity: 3, unit_price: item3.unit_price })

# InvoiceItem.create({ invoice_id: invoice2.id, item_id: item1.id, quantity: 10, unit_price: item1.unit_price })
# InvoiceItem.create({ invoice_id: invoice2.id, item_id: item3.id, quantity: 2, unit_price: item3.unit_price })

# InvoiceItem.create({ invoice_id: invoice3.id, item_id: item2.id, quantity: 7, unit_price: item2.unit_price })
# InvoiceItem.create({ invoice_id: invoice3.id, item_id: item4.id, quantity: 1, unit_price: item4.unit_price })

# InvoiceItem.create({ invoice_id: invoice4.id, item_id: item5.id, quantity: 1, unit_price: item5.unit_price })
# InvoiceItem.create({ invoice_id: invoice5.id, item_id: item6.id, quantity: 2, unit_price: item6.unit_price })
