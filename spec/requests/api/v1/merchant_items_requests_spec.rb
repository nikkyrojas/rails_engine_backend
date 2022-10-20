require 'rails_helper'

RSpec.describe 'Merchants Items API' do
    describe 'merchant items API endpoints'
    context 'Happy Path' do
        it "can get a merchants items" do
            id = create(:merchant).id
            create_list(:item, 5, merchant_id: id)

            get "/api/v1/merchants/#{id}/items"
            
            expect(response).to be_successful

            merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(merchant_items.count).to eq(5)

            merchant_items.each do |item|
                expect(item).to have_key(:id)
                expect(item[:id]).to be_a(String)
                expect(item).to have_key(:attributes)
                expect(item[:attributes][:name]).to be_a(String)
                expect(item[:attributes][:description]).to be_a(String)
                expect(item[:attributes][:unit_price]).to be_a(Float)
            end
        end
    end

    context 'Sad Path/Edgecase' do
        it "returns an error if merchant id does not exists" do 
            id = create(:merchant).id 
            merchant_items = create_list(:item, 5, merchant_id: id)

            get "/api/v1/merchants/12345/items"

            expect(response.status).to eq(404)
        end
    end
end
