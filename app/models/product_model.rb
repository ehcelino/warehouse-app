class ProductModel < ApplicationRecord
  validates :name, :weight, :width, :height, :depth, :sku, :supplier, presence: true
  belongs_to :supplier
end
