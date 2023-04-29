require 'rails_helper'

describe 'Usuário adiciona items ao pedido' do

  it 'com sucesso' do

    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 12345678912345678900)
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier, sku: 32145678912345678900)

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'
    select 'Produto A', from: 'Produto'
    fill_in 'Quantidade', with: '8'
    click_on 'Gravar'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '8 x Produto A'

  end

  it 'e não vê produtos de outro fornecedor' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier_a = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    supplier_b = Supplier.create!(corporate_name: 'Panasonic do Brasil LTDA', brand_name: 'Panasonic', registration_number: '1234567890321',
      full_address: 'Av da Saudade, 200', city: 'Guarulhos', state: 'SP', email: 'sac@panasonic.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier_a, sku: 12345678912345678900)
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20, depth: 30, supplier: supplier_b, sku: 32145678912345678900)

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    # Assert
    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B'
  end
end
