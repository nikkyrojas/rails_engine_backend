class Api::V1::MerchantItemsController < ApplicationController
    def index
        merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(merchant.items)
    end
    
    # def show
    #     render json: ItemSerializer.new(Item.find(params[:id])
    # end

    # private
    # def merchant_item_params
    #     params.require(:merchant).permit(:name, :description, :unit_price, :merchant_id) if params[:merchant]
    # end
end