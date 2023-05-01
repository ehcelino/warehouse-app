require 'rails_helper'

describe 'Usuário busca por um pedido' do

  it 'a partir do menu' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path

    # Assert
    within('header nav') do
      expect(page).to have_field('Buscar Pedido')
      expect(page).to have_button('Buscar')
    end

  end

  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within('header nav') do
      expect(page).not_to have_field('Buscar Pedido')
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um pedido' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
      full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

      # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content 'Galpão Destino: SDU | Rio'
    expect(page).to have_content 'Fornecedor: Amazonas LTDA'
  end

  it 'e encontra múltiplos pedidos' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    second_warehouse = Warehouse.new(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000', state: 'SP',
                                    description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
      full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('SDU12345')
    order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('SDU95815')
    order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('GRU12345')
    order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'SDU'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'SDU12345'
    expect(page).to have_content 'SDU95815'
    expect(page).to have_content 'Galpão Destino: SDU | Rio'
    expect(page).not_to have_content 'GRU12345'
    expect(page).not_to have_content 'Galpão Destino: GRU | Aeroporto SP'

  end
end
