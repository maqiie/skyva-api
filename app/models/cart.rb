
class Cart < ApplicationRecord
  belongs_to :user
  has_many :orders # Add this association
  has_many :cart_items, class_name: 'OrderItem', foreign_key: 'cart_id'

  has_many :order_items

 
  def create_current_cart
    if user.current_cart.nil?
      transaction do
        cart = Cart.create(user: user)
        user.update(current_cart: cart)
        cart
      end
    else
      user.current_cart
    end
  end
  
  def open_order
    # Find an open order associated with this cart
    open_order_item = order_items.find { |item| item.order.status == 'open' }

    if open_order_item.nil?
      # If there's no open order, create one
      order = Order.create(status: 'open')
      order_items.create(order: order)
    else
      order = open_order_item.order
    end

    order
  end

end



