class AddOrderIdToCarts < ActiveRecord::Migration[7.0]
  def change
    add_reference :carts, :order, foreign_key: true, null: true
  end
end
