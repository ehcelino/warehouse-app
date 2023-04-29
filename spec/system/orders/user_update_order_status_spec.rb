require 'rails_helper'

describe 'Usuário informa novo status de pedido' do

  it 'e pedido foi entregue' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5000, height: 100, width: 70, depth: 75, sku: 'CADEIRA-09112-XPTO01')
    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date, status: :pending)
    OrderItem.create!(order: order, product_model: product, quantity: 5)

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content('Situação do Pedido: Entregue')
    expect(page).not_to have_button('Marcar como CANCELADO')
    expect(page).not_to have_button('Marcar como ENTREGUE')
    expect(StockProduct.count).to eq 5
    stock = StockProduct.where(product_model: product, warehouse: warehouse).count
    expect(stock).to eq 5
  end

  it 'e pedido foi cancelado' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5000, height: 100, width: 70, depth: 75, sku: 'CADEIRA-09112-XPTO01')
    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date, status: :pending)
    OrderItem.create!(order: order, product_model: product, quantity: 5)

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content('Situação do Pedido: Cancelado')
    expect(StockProduct.count).to eq 0
  end

end
