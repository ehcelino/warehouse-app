require 'rails_helper'

describe 'Usuário vê detalhes de um fornecedor' do
  it 'e vê informações adicionais' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123', 
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Amazonas'

    # Assert
    expect(page).to have_content('Fornecedor Amazonas')
    expect(page).to have_content('Amazonas LTDA')
    expect(page).to have_content('Documento: 1234567890123')
    expect(page).to have_content('Endereço: Av Central, 1000 - Manaus - AM')
    expect(page).to have_content('E-mail: comercial@amazonas.com')
  end

  it 'e volta para a tela inicial' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com') 
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Amazonas'
    click_on 'Voltar'
    # Assert
    expect(current_path).to eq(root_path)
  end

end