require 'rails_helper'

RSpec.describe 'Items API' do
    describe 'items API endpoints'
    context 'Happy Path' do
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

        it "can update an item" do
            id = create(:item).id
            previous_name = Item.last.name
            previous_description= Item.last.description
            previous_unit_price = Item.last.unit_price
            item_params = ({
                    name: 'Hard Cover Book',
                    description: 'Twilight Book: Eclipse',
                    unit_price: 11.50
                    })
            headers = {"CONTENT_TYPE" => "application/json"}

            patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
            item = Item.find_by(id: id)

            expect(response).to be_successful
            expect(item.name).to_not eq(previous_name)
            expect(item.name).to eq("Hard Cover Book")
            expect(item.description).to_not eq(previous_description)
            expect(item.description).to eq("Twilight Book: Eclipse")
            expect(item.unit_price).to_not eq(previous_unit_price)
            expect(item.unit_price).to eq(11.50)

        end

        it "can destroy an item" do
            item = create(:item)

            expect(Item.count).to eq(1)

            delete "/api/v1/items/#{item.id}"
            expect(response).to be_successful
            expect(response.status).to eq(204)
            expect(Item.count).to eq(0)
            expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "can destroy an item" do
            item = create(:item)

            expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

            expect(response).to be_successful
            expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
        
        it "can get merchant data from an item" do
            merchant = create(:merchant) 
            merchant2 = create(:merchant) 
            item = create(:item, merchant_id: merchant.id)
        
            get "/api/v1/items/#{item.id}/merchant"
            
            expect(response).to be_successful

            item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]

            expect(item_merchant).to have_key(:attributes)
            expect(item_merchant[:id]).to be_a(String)
            expect(item_merchant[:type]).to eq("merchant")
            expect(item_merchant[:attributes][:name]).to be_a(String)
            expect(item_merchant[:id]).to_not eq(merchant2.id)
        end
    end
    context 'Sad Path/Edgecase' do
        it "returns an error if item id does not exist" do
            merchant = create(:merchant) 
            merchant2 = create(:merchant) 
            item = create(:item, merchant_id: merchant.id)

            get "/api/v1/items/12345"
            
            expect(response.status).to eq(404)
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
    end
end
