class Warehouse < ApplicationRecord
  validates :name, :description, :code, :address, :city, :cep, :area, :state, presence: true
  validates :code, length: { is: 3 }
  validates :code, :name, uniqueness: true
  validate :cep_must_follow_rule

  def cep_must_follow_rule
    unless cep =~ /\d{5}-\d{3}/
      errors.add(:cep, 'deve ser no formato xxxxx-xxx')
    end
  end

  def full_description
    "#{code} | #{name}"
  end

end
