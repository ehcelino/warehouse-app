require 'rails_helper'

describe 'Usuário visita tela de fornecedores' do
  it 'e vê a lista de fornecedores vazia' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end

    # Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content('Fornecedores')
    expect(page).to have_content('Nenhum fornecedor cadastrado.')
  end

  it 'e vê fornecedores cadastrados' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                    full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    Supplier.create!(corporate_name: 'Panasonic do Brasil LTDA', brand_name: 'Panasonic', registration_number: '1234567890321',
                    full_address: 'Av da Saudade, 200', city: 'Guarulhos', state: 'SP', email: 'sac@panasonic.com')

    # Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content('Fornecedores')
    expect(page).to have_content('Amazonas')
    expect(page).to have_content('Manaus - AM')
    expect(page).to have_content('Panasonic')
    expect(page).to have_content('Guarulhos - SP')
    expect(page).not_to have_content('Nenhum fornecedor cadastrado.')
  end
end
