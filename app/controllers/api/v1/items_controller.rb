# frozen_string_literal: true
module Api
  module V1
    class ItemsController < ApplicationController
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
        if !params[:name].nil?
          items = Item.find_name(params[:name])
          if items.empty? || params[:name] == '' then render json: { data: { Message: 'No Item(s) Found' } }, status: 400
          else render json: ItemSerializer.new(items.first) end
        elsif !params[:min_price].nil? && !params[:max_price].nil?
          if params[:max_price] > params[:min_price] && params[:min_price] != ''
            items = Item.find_min(params[:min_price])
            render json: ItemSerializer.new(items.first)
          elsif params[:min_price] < '0' && params[:max_price] > '500000000'
            render json: { data: { Error: 'min_price is too small or max price is too large' } }, status: 400
          elsif params[:min_price] > params[:max_price]
            render json: { data: { Error: 'min_price cannot be more than max_price' } }, status: 400
          elsif params[:min_price] > '500000000' || params[:max_price] < '0'
            render json: { data: { Error: 'min_price is too large or max_price is too small' } }, status: 200
          else
            render json: { data: { Message: 'No Item(s) Found' } }, status: 400
          end
        elsif !params[:min_price].nil? || params[:min_price] != ''
          if params[:min_price] != ''
            items = Item.find_min(params[:min_price])
            render json: ItemSerializer.new(items.first)
          else
            render json: { data: { Message: 'No Item(s) Found' } }, status: 400
          end
        elsif !params[:max_price].nil? || params[:max_price] != ''
          if params[:max_price] != ''
            items = Item.find_max(params[:max_price])
            render json: ItemSerializer.new(items.first)
          else
            render json: { data: { Message: 'No Item(s) Found' } }, status: 400
          end
        else
          render json: { data: { Message: 'No Item(s) Found' } }, status: 400
        end
      end

      def find_all
        if !params[:name].nil?
          items = Item.find_name(params[:name])
          if items.empty? || params[:name] == '' then render json: { data: [] }, status: 400 else
            render json: ItemSerializer.new(items) end
        elsif !params[:min_price].nil?
          items = Item.find_min(params[:min_price])
          render json: ItemSerializer.new(items)
        else
          render json: { data: { Message: 'No Item(s) Found' } }, status: 400
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
  end
end
