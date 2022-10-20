class Api::V1::MerchantsController < ApplicationController
    def index 
        render json: MerchantSerializer.new(Merchant.all)
    end
    
    def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end

    def find
        if params[:name] != nil
            merchant = Merchant.where("name ILIKE ?", "%#{params[:name].downcase}%") 
            if merchant.empty? || params[:name] == "" then render json: { data: {Message: "No Merchants Found"}}, status: 400
            else render json: MerchantSerializer.new(merchant.first) end
        else
            render json: { data: {Message: "No Merchants Found"}}, status: 400
        end
    end

    def find_all
        if params[:name] != nil
            merchant = Merchant.where("name ILIKE ?", "%#{params[:name].downcase}%") 
            if merchant.empty? || params[:name] == "" 
                render json: { data: {Message: "No Merchants Found"}}, status: 400
            else
                render json: MerchantSerializer.new(merchant)
            end
        else
            render json: { data: {Message: "No Merchants Found"}}, status: 400
        end
    end
end