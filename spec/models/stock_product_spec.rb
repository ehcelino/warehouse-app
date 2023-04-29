require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'Gera um número de série' do

    it 'ao criar um StockProduct' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
        address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
        description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
            full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered, estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 12345678912345678900)
      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      #Assert
      expect(stock_product.serial_number.length).to eq(20)

    end


    it 'e não é modificado' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
        address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
        description: 'Galpão destinado para cargas internacionais')
      other_warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
        address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
            full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered, estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 12345678912345678900)
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      original_serial_number = stock_product.serial_number
      # Act
      stock_product.update!(warehouse: other_warehouse)

      # Assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end

  describe '#available?' do

    it 'true se não tiver destino' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
        address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
        description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
            full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered, estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 12345678912345678900)
      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)


      # Assert
      expect(stock_product.available?).to eq true
    end

    it 'false se tiver destino' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
        address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
        description: 'Galpão destinado para cargas internacionais')
      user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
      supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
            full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered, estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 12345678912345678900)
      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'João', address: 'Rua Tal')

      # Assert
      expect(stock_product.available?).to eq false

    end
  end
end
