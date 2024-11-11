require 'rails_helper'

describe 'Finding Customers By Merchant' do
  before(:all) do
    Invoice.delete_all
    Customer.delete_all
    Merchant.delete_all
  end

  it 'can return customers for a merchant' do
    merchant1 = Merchant.create(name: "Little Shop Of Horrors")
    m1id = merchant1.id
    merchant2 = Merchant.create(name: "Large Shop Of Wonders")
    m2id = merchant2.id

    customer1 = Customer.create(first_name: "Bugs", last_name: "Bunny")
    customer2 = Customer.create(first_name: "Roger", last_name: "Rabbit")
    
    invoice1 = Invoice.create(customer_id: customer1.id, merchant_id: m1id, status: "shipped")
    invoice2 = Invoice.create(customer_id: customer2.id, merchant_id: m2id, status: "shipped")
    invoice3 = Invoice.create(customer_id: customer1.id, merchant_id: m2id, status: "shipped")
    
    # HAPPY PATH
    get "/api/v1/merchants/#{m1id}/customers"
    firstMerchant = JSON.parse(response.body) 

    expect(response).to be_successful
    expect(firstMerchant["data"][0]["type"]).to eq("customer")
    expect(firstMerchant["data"][0]["attributes"]["first_name"]).to eq("Bugs")

    get "/api/v1/merchants/#{m2id}/customers"
    secondMerchant = JSON.parse(response.body)

    expect(response).to be_successful;
    expect(secondMerchant["data"][0]["type"]).to eq("customer")
    expect(secondMerchant["data"][1]["attributes"]["first_name"]).to eq("Roger")

    # SAD PATH
    get "/api/v1/merchants/#{54321}/customers"
    
    expect(response).to_not be_successful
    expect(response.code).to eq("404")
    
    data = JSON.parse(response.body, symbolize_names: true) 
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=54321")
  end

  it 'has a sad path for when a merchant is not found' do
    get "/api/v1/merchants/9999999/customers" # ID 0 should not exist

    expect(response).to have_http_status(:not_found)
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response[:message]).to eq("Your query could not be completed")
    expect(error_response[:errors]).to be_an(Array)
    expect(error_response[:errors].first[:status]).to eq("404")
    expect(error_response[:errors].first[:title]).to include("Couldn't find Merchant")
  end
end