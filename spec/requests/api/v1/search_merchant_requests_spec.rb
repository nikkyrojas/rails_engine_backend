# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchants Search API Request' do
  describe 'merchant search endpoints;'
  context 'Happy Path' do
    it 'if search results show no match, returns: no merchant matches search ' do
      m1 = Merchant.create!(name: 'Cardi B')
      m2 = Merchant.create!(name: 'Nicki Minaj')

      get '/api/v1/merchants/find?name=Saweetie'

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.body).to include('No Merchants Found')
    end
  end

  context 'Sad Path/Edgecase' do
    it 'finds merchant by partial name search/edgecase' do
      m1 = Merchant.create!(name: 'Cardi B')
      m2 = Merchant.create!(name: 'Nicki Minaj')

      get '/api/v1/merchants/find?name=cARd'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes][:name]).to eq(m1.name)
      expect(merchant[:attributes][:name]).to_not eq(m2.name)
    end
    it 'if search results is empty it returns an error ' do
      m1 = Merchant.create!(name: 'Cardi B')
      m2 = Merchant.create!(name: 'Nicki Minaj')

      get '/api/v1/merchants/find'

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.body).to include('No Merchants Found')
    end

    it 'if search results name fragment is empty ('') it returns an error ' do
      m1 = Merchant.create!(name: 'Cardi B')
      m2 = Merchant.create!(name: 'Nicki Minaj')

      get '/api/v1/merchants/find?name='

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.body).to include('No Merchants Found')
    end
  end
end
