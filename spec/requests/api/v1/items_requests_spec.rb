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

    it "creates an item" do 
        merchant_id = create(:merchant).id

        item_params = ({
                        name: 'Book',
                        description: 'Twilight Book: New Moon',
                        unit_price: 10.50,
                        merchant_id: merchant_id 
                        })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params) 
        
        expect(response).to be_successful 
        expect(response.status).to eq(201)

        created_item = Item.last

        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.name).to eq('Book')
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "does not creates an item when fields are missing returns 404 response status" do 
        merchant_id = create(:merchant).id

        item_params = ({
                        name: 'Book',
                        description: 'Twilight Book: New Moon',
                        unit_price: 10.50
                        })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params) 
        
        expect(response.status).to eq(404)
    end

    xit "can edit an item" do
        merchant_id = create(:merchant).id

    end

    it "can destroy an item" do
        item = create(:item)

        expect(Item.count).to eq(1)

        delete "/api/v1/items/#{item.id}"
        expect(response).to be_success
        # expect(response.status).to eq(204)
        expect(Item.count).to eq(0)
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    # it "can destroy an item" do
    #   item = create(:item)

    #   expect{ delete "/api/v1/items/#{item.id}" }.to change(item, :count).by(-1)

    #   expect(response).to be_success
    #   expect{item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    # end
    xit "can get merchant data from an item" do
        merchant_id = create(:merchant).id

    end
end



# Items:
# get all items
# get one item
# create an item
# edit an item
# delete an item
# get the merchant data for a given item ID