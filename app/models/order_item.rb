
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :cart 

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  after_save :update_order_total_amount
  after_destroy :update_order_total_amount

  private

  def update_order_total_amount
    # Find the associated order
    current_order = self.order

    # Calculate the total amount based on all order items of the order
    total_amount = current_order.order_items.sum { |item| item.quantity * item.product.price }

    # Update the total_amount attribute of the order
    current_order.update_column(:total_amount, total_amount)
  end
end
