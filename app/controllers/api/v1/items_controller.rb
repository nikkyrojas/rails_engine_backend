class Api::V1::ItemsController < ApplicationController
    def index
        # binding.pry
        render json: Item.find_all(:merchant_id => params[:merchant_id])
        #  render json: ItemSerializer.format_items(Item.all)
        # render json: Item.find(params[:merchant_id])
    end
    
    # def show
    #     render json: Item.find(params[:id]) 
    # end

    private
    def item_params
        params.require(:merchant).permit(:name, :description, :unit_price, :merchant_id) if params[:merchant]
    end
end