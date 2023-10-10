class AddCartReferenceToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :cart, null: false, foreign_key: true, default: Cart.first&.id
  end
end
