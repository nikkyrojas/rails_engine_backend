require 'rails_helper'

RSpec.describe 'Merchants API' do
    describe 'merchant items API endpoints'
    context 'Happy Path' do
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
    end
end
