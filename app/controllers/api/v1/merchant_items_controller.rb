class Api::V1::MerchantItemsController < ApplicationController
    def show
        if Merchant.exists?(params[:merchant_id])
            merchant = Merchant.find(params[:merchant_id])
            render json: ItemSerializer.new(merchant.items)
        else
            render json: {error: "your query could not be completed"}, status: 404
        end
    end
end