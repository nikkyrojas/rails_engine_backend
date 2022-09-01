class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end
    
    def show
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def update
        item = Item.update(params[:id], item_params)
        if item.update(item_params)
            render json: ItemSerializer.new(item)
        else
            render status: 404
        end
    end

#       def update
#     pet = Pet.find(params[:id])
#     if pet.update(pet_params)
#       redirect_to "/pets/#{pet.id}"
#     else
#       redirect_to "/pets/#{pet.id}/edit"
#       flash[:alert] = "Error: #{error_message(pet.errors)}"
#     end
#   end
    def create
        item = Item.new(item_params)
        if item.save 
            render json: ItemSerializer.new(item), status: 201
        else 
            render status: 404
        end
    end

    def destroy
        render json: Item.delete(params[:id])
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
        # params.require(:item).permit(:name, :description, :unit_price, :merchant_id) if params[:merchant]
    end
end