class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end
    
    def show
        if Item.exists?(params[:id])
            item = Item.find(params[:id])
            render json: ItemSerializer.new(Item.find(params[:id]))
        else
            render status: 404
        end
    end
    def find
        if params[:name] != nil
            items = Item.where("name ILIKE ?", "%#{params[:name].downcase}%")
            if items.empty? || params[:name] == "" then render json: { data: ["No Item(s) Found"] }, status: 400 else render json: ItemSerializer.new(items.first) end
        elsif params[:min_price] != nil || params[:min_price] != "" 
            unless params[:min_price] == ""
                items = Item.where('unit_price >= ?', params[:min_price])
                render json: ItemSerializer.new(items.first)
            else render json: { data: {Message: "No Item(s) Found"}}, status: 400
            end
        else render json: { data: {Message: "No Item(s) Found"}}, status: 400
        end
    end
    
    def find_all
        if params[:name] != nil 
            items = Item.where("name ILIKE ?", "%#{params[:name].downcase}%")
            if items.empty? || params[:name] == "" then render json: { data: [] } else render json: ItemSerializer.new(items) end
        elsif params[:min_price] != nil
            items = Item.where('unit_price >= ?', params[:min_price])
            render json: ItemSerializer.new(items)
        else render json: { data: {Message: "No Item(s) Found"}}, status: 400
        end
    end

    def update
        item = Item.update(params[:id], item_params)
        if item.update(item_params)
            render json: ItemSerializer.new(item), status: 202
        else
            render status: 404
        end
    end

    def create
        item = Item.new(item_params)
        if item.save 
            render json: ItemSerializer.new(item), status: 201
        else 
            render status: 404
        end
    end

    def destroy
        render json: Item.delete(params[:id]), status: 204
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id) 
        # params.require(:item).permit(:name, :description, :unit_price, :merchant_id) if params[:merchant]
    end
end