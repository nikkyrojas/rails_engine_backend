# frozen_string_literal: true

module Api
  module V1
    class ItemMerchantController < ApplicationController
      def show
        item = Item.find(params[:item_id])
        merchant = item.merchant
        render json: MerchantSerializer.new(merchant)
      end
    end
  end
end
