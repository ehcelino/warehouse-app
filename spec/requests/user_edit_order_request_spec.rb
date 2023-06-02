require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    # Arrange
    andre = User.create!(name:'André', email: 'andre@email.com', password: 'password')
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    login_as(andre)
    patch(order_path(order.id), params: {order: { supplier_id: 3 }})

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'com sucesso' do
    # Arrange
    andre = User.create!(name:'André', email: 'andre@email.com', password: 'password')
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    login_as(joao)
    patch(order_path(order.id), params: {order: { supplier_id: 3 }})

    # Assert
    expect(response).to redirect_to(order_path(order.id))
  end
end
