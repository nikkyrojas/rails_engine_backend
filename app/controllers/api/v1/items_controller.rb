class Api::V1::ItemsController < ApplicationController
    def index
        binding.pry
        render json: Merchant.find(params[:id]   
    end
    
    # def show
    #     render json: Item.find(params[:id]) 
    # end
end