class ProductModel < ApplicationRecord
  validates :name, :weight, :width, :height, :depth, :sku, :supplier, presence: true
  validates :sku, length: { is: 20 }
  validates :sku, uniqueness: true
  validates :weight, :width, :height, :depth, numericality: { greater_than: 0 }
  belongs_to :supplier
  has_many :order_items
  has_many :orders, through: :order_items
end
