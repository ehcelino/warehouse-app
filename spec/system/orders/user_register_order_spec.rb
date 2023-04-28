require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path
    click_on 'Registrar Pedido'

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
                                  address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    Supplier.create!(corporate_name: 'Panasonic do Brasil LTDA', brand_name: 'Panasonic', registration_number: '1234567890321',
                     full_address: 'Av da Saudade, 200', city: 'Guarulhos', state: 'SP', email: 'sac@panasonic.com')

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    delivery_date = 1.day.from_now.strftime("%d/%m/%Y")

    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'SDU | Rio', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: delivery_date
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido registrado com sucesso.'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: SDU | Rio'
    expect(page).to have_content 'Fornecedor: Amazonas LTDA'
    expect(page).to have_content 'Usuário Responsável: Sergio - sergio@email.com'
    expect(page).to have_content "Data Prevista de Entrega: #{delivery_date}"
    expect(page).to have_content "Situação do Pedido: Pendente"
    expect(page).not_to have_content 'Aeroporto SP'
    expect(page).not_to have_content 'Panasonic do Brasil LTDA'
  end

  it 'e não informa a data de entrega' do
    # Arrange
    user = User.create!(name:'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
                                  address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'SDU | Rio', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Gravar'
    # Assert
    expect(page).to have_content 'Não foi possível registrar o pedido.'
    expect(page).to have_content 'Data Prevista de Entrega não pode ficar em branco'
  end

end
