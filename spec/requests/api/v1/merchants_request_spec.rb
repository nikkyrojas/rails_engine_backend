require 'rails_helper'

RSpec.describe 'Merchants API' do
    it 'sends a list of merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants'
  

        merchants = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(merchants.count).to eq(3)
       

        merchants.each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_a(String)
            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes][:name]).to be_a(String)
        end
    end

    it "can get one merchant by its id" do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"
     
        merchant = JSON.parse(response.body, symbolize_names: true)[:data]
        binding.pry
        # response_body = JSON.parse(response.body, symbolize_names: true)
        # merchant = response_body[:data]
        expect(response).to be_successful
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
    end
end
