class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  has_many :order_items, foreign_key: 'order_id'


  def calculate_total_amount
    self.total_amount = order_items.sum { |item| item.quantity * item.product.price }
  end
end
