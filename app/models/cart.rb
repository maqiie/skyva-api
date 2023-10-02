# class Cart < ApplicationRecord
#   belongs_to :user
#   has_many :cart_items, class_name: 'CartItem', dependent: :destroy



# end
class Cart < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  # Add a product to the cart
  def add_product(product_id, quantity)
    # Find the product
    product = Product.find(product_id)

    # Check if the product is already in the cart
    order_item = order_items.find_by(product_id: product_id)

    if order_item
      # If the product is already in the cart, update its quantity
      order_item.update(quantity: order_item.quantity + quantity.to_i)
    else
      # If the product is not in the cart, create a new order_item
      order_item = order_items.build(product: product, quantity: quantity)
    end

    # Save the cart (if it's not already saved)
    save if new_record?
    
    # Save the order item
    order_item.save
  end
end
