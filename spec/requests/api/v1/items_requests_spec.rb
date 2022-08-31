require 'rails_helper'

RSpec.describe 'Items API' do
    it "api call can get all items" do
        create_list(:item, 5)

        get "/api/v1/items"
        
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(items.count).to eq(5)

        items.each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_a(String)
            expect(item).to have_key(:attributes)
            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes][:description]).to be_a(String)
            expect(item[:attributes][:unit_price]).to be_a(Float)
        end
    end

    it "api call can get one item by ID" do
         id = create(:item).id

        get "/api/v1/items/#{id}"
        
        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
    end
end



# Items:
# get all items
# get one item
# create an item
# edit an item
# delete an item
# get the merchant data for a given item ID