require 'rails_helper'

RSpec.describe 'Merchants API' do
    it 'sends a list of merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants'
        
        expect(response).to be_successful
  
        merchants = JSON.parse(response.body, symbolize_names: true)[:data]

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
        
        expect(response).to be_successful
     
        merchant = JSON.parse(response.body, symbolize_names: true)[:data]
       
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
    end

    it "finds merchant by partial name search/edgecase" do 
        m1 = Merchant.create!(name: "Cardi B")
        m2 = Merchant.create!(name: "Nicki Minaj")

        get "/api/v1/merchants/find?name=cARd"

        expect(response).to be_successful

        matches_merchants = JSON.parse(response.body, symbolize_names: true)[:data]
        merchant = matches_merchants.first

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes][:name]).to eq(m1.name)
        expect(merchant[:attributes][:name]).to_not eq(m2.name)

    end
  
    it "if search results show no match, returns: no merchant matches search " do 
        m1 = Merchant.create!(name: "Cardi B")
        m2 = Merchant.create!(name: "Nicki Minaj")

        get "/api/v1/merchants/find?name=Saweetie"

        merchant = JSON.parse(response.body, symbolize_names: true)[:data]

        # expect(merchant).to eq("{}")
        expect(response.body).to include("No Merchants Found")
    end
end
