# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items Search API Request' do
  describe 'item search endpoints;'
  context 'Happy Path' do
    it 'searches for all items matching the name' do
      merchant = create(:merchant)

      balloon = Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
      alter = Item.create!(name: 'Alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

      get '/api/v1/items/find_all?name=al'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq 3

      expect(items[:data][0][:attributes][:name]).to eq 'Balloon'
      expect(items[:data][1][:attributes][:name]).to eq 'Ball'
      expect(items[:data][2][:attributes][:name]).to eq 'Alter'
    end

    it 'returns an empty array for the data if no items match the name query' do
      merchant = create(:merchant)

      balloon = Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
      alter = Item.create!(name: 'alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

      get '/api/v1/items/find_all?name=nomatch'

      expect(response).to_not be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to eq([])
    end

    it 'searches for all items matching the minimum price' do
      merchant = create(:merchant)

      doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
      hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
      scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

      get '/api/v1/items/find_all?min_price=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq 2

      expect(items[:data][0][:attributes][:name]).to eq 'Pencil'
      expect(items[:data][1][:attributes][:name]).to eq 'Scarf'
    end
    it 'searches for one item matching the minimum price' do
      merchant = create(:merchant)

      doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
      hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
      scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

      get '/api/v1/items/find?min_price=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
  
      expect(items.count).to eq 1

      expect(items[:data][:attributes][:name]).to eq 'Pencil'
      expect(items[:data][:attributes][:name]).to_not eq 'Scarf'
    end
    
    it 'min_price is so big that nothing matches' do
      merchant = create(:merchant)

      doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
      hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
      scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

      get '/api/v1/items/find?min_price=500000000'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to eq(nil)
    end
  end

  context 'Sad Path/Edge Case' do
    it 'edgecase: searches for one item with min_price param missing' do
      merchant = create(:merchant)

      doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
      hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
      scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

      get '/api/v1/items/find?min_price='

      expect(response).to_not be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq 1
      expect(response.body).to include('No Item(s) Found')
    end
    it 'edge case: if no param given when searching many items' do
      merchant = create(:merchant)

      balloon = Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
      alter = Item.create!(name: 'alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

      get 'http://localhost:3000/api/v1/items/find_all'

      expect(response).to_not be_successful

      expect(response.body).to include('No Item(s) Found')

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data]).to be_a Hash
    end

    it 'edge case: if no param given when searching for single item' do
      merchant = create(:merchant)

      balloon = Item.create!(name: 'Balloon', description: 'blue balloons', unit_price: 3.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'orange ball', unit_price: 4.0, merchant_id: merchant.id)
      alter = Item.create!(name: 'alter', description: 'tall alter', unit_price: 3.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 1.0, merchant_id: merchant.id)

      get 'http://localhost:3000/api/v1/items/find?name='

      expect(response).to_not be_successful

      expect(response.body).to include('No Item(s) Found')

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data]).to be_a Hash
    end

    it 'edgecase: min price cant be more than max' do
      merchant = create(:merchant)

      doll = Item.create!(name: 'Barbie', description: 'barbie doll', unit_price: 3.0, merchant_id: merchant.id)
      hat = Item.create!(name: 'Hat', description: 'black hat', unit_price: 4.0, merchant_id: merchant.id)
      scarf = Item.create!(name: 'Scarf', description: 'winter scarf', unit_price: 76.0, merchant_id: merchant.id)
      pencil = Item.create!(name: 'Pencil', description: '#2 pencil', unit_price: 52.0, merchant_id: merchant.id)

      get '/api/v1/items/find?min_price=50&max_price=5'

      expect(response).to_not be_successful

      expect(response.body).to include('min_price cannot be more than max_price')
    end
  end
end
