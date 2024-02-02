class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :cart 
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }



  after_save :update_order_total_amount
  after_destroy :update_order_total_amount

  private

  def update_order_total_amount
    order.calculate_total_amount
    order.save
  end
end


