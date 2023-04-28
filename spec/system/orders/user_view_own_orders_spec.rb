require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(current_path).to eq new_user_session_path

  end

  it 'e não vê outros pedidos' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    sergio = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    first_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: 'pending')
    second_order = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: 'delivered')
    third_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now, status: 'canceled')

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content second_order.code
    expect(page).not_to have_content 'Entregue'
    expect(page).to have_content third_order.code
    expect(page).to have_content 'Cancelado'

  end

  it 'e visita um pedido' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    formatted_date = I18n.localize(1.day.from_now.to_date)
    first_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on first_order.code

    # Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Galpão Destino: GRU | Aeroporto SP'
    expect(page).to have_content 'Fornecedor: Amazonas LTDA'
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'e não visita pedidos de outros usuários' do
    # Arrange
    andre = User.create!(name:'André', email: 'andre@email.com', password: 'password')
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    formatted_date = I18n.localize(1.day.from_now.to_date)
    first_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    login_as(andre)
    visit order_path(first_order.id)

    # Assert
    expect(current_path).not_to eq order_path(first_order.id)
    expect(current_path).to eq root_path
    expect(page).to have_content "Você não possui acesso a este pedido."
  end
end
