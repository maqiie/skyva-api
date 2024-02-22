class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  scope :on_offer, -> { where(on_offer: true) }
  scope :recently_added, -> { order(created_at: :desc) }
end
