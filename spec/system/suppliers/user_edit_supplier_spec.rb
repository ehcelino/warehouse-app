require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'e vê os dados previamente cadastrados' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123', 
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Amazonas'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar fornecedor'
    expect(page).to have_field('Nome Fantasia', with: 'Amazonas')
    expect(page).to have_field('Razão Social', with: 'Amazonas LTDA')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade', with: 'Manaus')
    expect(page).to have_field('Estado', with: 'AM')
    expect(page).to have_field('E-mail')
  end

  it 'com sucesso' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123', 
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Amazonas'
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: 'Amazonas Brasil'
    fill_in 'Endereço', with: 'Av Central, 3000'
    fill_in 'E-mail', with: 'faleconosco@amazonas.com'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content('Fornecedor atualizado com sucesso.')
    expect(page).to have_content('Fornecedor Amazonas Brasil')
    expect(page).to have_content('Endereço: Av Central, 3000 - Manaus - AM')
    expect(page).to have_content('E-mail: faleconosco@amazonas.com')
  end
end