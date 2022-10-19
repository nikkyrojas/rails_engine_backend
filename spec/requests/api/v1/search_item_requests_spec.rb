require 'rails_helper'

RSpec.describe 'Items Search API Request' do
it 'searches for all items matching the name' do 
    merchant = create(:merchant)

    balloon= Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
    alter = Item.create!(name: 'Alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
    pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=al"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 3
    
    expect(items[:data][0][:attributes][:name]).to eq 'Balloon'
    expect(items[:data][1][:attributes][:name]).to eq 'Ball'
    expect(items[:data][2][:attributes][:name]).to eq 'Alter'
  end

  it 'returns an empty array for the data if no items match the name query' do 
    merchant = create(:merchant)

    balloon= Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
    alter = Item.create!(name: 'alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
    pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=nomatch"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to eq([])
  end

  it 'searches for all items matching the minimum price' do 
    merchant = create(:merchant)

    doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
    hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
    scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
    pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?min_price=50"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 2
    
    expect(items[:data][0][:attributes][:name]).to eq 'Scarf'
    expect(items[:data][1][:attributes][:name]).to eq 'Pencil'
  end

    it 'edge case if no param given' do 
    merchant = create(:merchant)

    balloon= Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
    alter = Item.create!(name: 'alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
    pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

    get "http://localhost:3000/api/v1/items/find_all"
    
    expect(response).to_not be_successful

    expect(response.body).to include("No Item(s) Found")
    
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data]).to be_a Hash
  end
end