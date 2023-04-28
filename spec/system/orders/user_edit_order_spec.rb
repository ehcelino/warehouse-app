require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                        full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    other_supplier = Supplier.create!(corporate_name: 'LG Eletrônicos LTDA', brand_name: 'LG', registration_number: '1234567890321',
                                      full_address: 'Av Ibirapuera, 1000', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    formatted_date = I18n.localize(1.day.from_now.to_date)
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '12/12/2023'
    select 'LG Eletrônicos LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content 'Fornecedor: LG Eletrônicos LTDA'
    expect(page).to have_content 'Data Prevista de Entrega: 12/12/2023'
  end

  it 'caso seja o responsável' do
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
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq root_path
  end

end
