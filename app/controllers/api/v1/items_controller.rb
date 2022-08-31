class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end
    
    # def show
    #     render json: ItemSerializer.new(Item.find(params[:id])
    # end

    # private
    # def item_params
    #     params.permit(:name, :description, :unit_price, :merchant_id) if params[:merchant]
    # end
end