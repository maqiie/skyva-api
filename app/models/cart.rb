

# class Cart < ApplicationRecord
#   belongs_to :user
#   has_many :order_items, dependent: :destroy
#   # has_many :orders

#   def open_order
#     order = orders.find_by(status: 'open')
#     order ||= orders.create(status: 'open')
#     order
#   end
# end

class Cart < ApplicationRecord
  belongs_to :user
  has_many :order_items

  def create_current_cart
    if current_cart.nil?
      cart = Cart.create(user: user)  # Change `self` to `user`
      user.update(current_cart: cart)  # Change `self` to `user`
      cart
    else
      current_cart
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


