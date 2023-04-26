require 'rails_helper'

RSpec.describe Order, type: :model do

  describe '#valid?' do
    it 'deve ter um código' do

      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                  full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2022-10-01')

      # Act
      result = order.valid?

      #Assert
      expect(result).to be true

    end
  end

  describe 'Gera um código aleatório' do
    it 'ao criar um novo pedido' do

      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                  full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2022-10-01')

      # Act
      order.save!
      result = order.code

      #Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8

    end

    it 'e o código é único' do

      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                  full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2022-10-01')
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2022-11-15')

      # Act
      second_order.save!

      #Assert
      expect(second_order.code).not_to eq first_order.code

    end

  end
end
