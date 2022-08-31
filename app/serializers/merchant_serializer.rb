class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :items
end

# class MerchantSerializer
#  def self.format_merchants(merchants)
#      {data: merchants.map do |merchant|
#         {
#             id: merchant.id,
#             type: 'merchant',
#             attributes: {
#                 name: merchant.name,
#             },
#             relationships: {
#                 items: {
#                     data: merchant.items.map do |item|
#                         {
#                             id: item.id,
#                             name: item.name
#                         }
#                     end
#                 }
#             }
#         }
#         end
#      } 
#     end
# end