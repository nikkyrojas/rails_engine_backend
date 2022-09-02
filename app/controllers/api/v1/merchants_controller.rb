class Api::V1::MerchantsController < ApplicationController
    def index 
        render json: MerchantSerializer.new(Merchant.all)
    end
    
    def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end

    def find
        merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
 
        if merchant.empty?
            render json: { data: {Message: "No Merchants Found"}}
        else
            render json: MerchantSerializer.new(merchant)
        end
    end
end