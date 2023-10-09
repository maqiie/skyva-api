
# class Cart < ApplicationRecord
#   belongs_to :user
#   has_many :order_items, dependent: :destroy
  
#   has_many :cart_items
  
  
  
# end
class Cart < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :cart_items, class_name: 'CartItem' # Ensure 'CartItem' matches the actual name of your CartItem model class
end
