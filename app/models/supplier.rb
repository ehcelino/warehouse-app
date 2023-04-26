class Supplier < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_number, :email, presence: true
  validates :registration_number, uniqueness: true
  validates :registration_number, length: { is: 13 }

  has_many :product_models
end
