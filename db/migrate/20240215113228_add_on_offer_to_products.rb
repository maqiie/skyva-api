class AddOnOfferToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :on_offer, :boolean
  end
end
