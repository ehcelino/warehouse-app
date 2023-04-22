require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'

    # Assert
    expect(current_path).to eq new_supplier_path
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('E-mail')
  end

  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: 'Amazonas'
    fill_in 'Razão Social', with: 'Amazonas LTDA'
    fill_in 'CNPJ', with: '1234567890123'
    fill_in 'Endereço', with: 'Av Central, 1000'
    fill_in 'Cidade', with: 'Manaus'
    fill_in 'Estado', with: 'AM'
    fill_in 'E-mail', with: 'comercial@amazonas.com'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content('Fornecedor cadastrado com sucesso.')
    expect(page).to have_content('Fornecedor Amazonas')
    expect(page).to have_content('Amazonas LTDA')
    expect(page).to have_content('Documento: 1234567890123')
    expect(page).to have_content('Endereço: Av Central, 1000 - Manaus - AM')
    expect(page).to have_content('E-mail: comercial@amazonas.com')

  end

  it 'com campos incompletos' do
    # Arrange
    
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    click_on 'Enviar'
    
    # Assert
    expect(page).to have_content("Fornecedor não cadastrado.")
    expect(page).to have_content("Nome Fantasia não pode ficar em branco")
    expect(page).to have_content("Razão Social não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("Endereço não pode ficar em branco")
    expect(page).to have_content("Cidade não pode ficar em branco")
    expect(page).to have_content("Estado não pode ficar em branco")
    expect(page).to have_content("E-mail não pode ficar em branco")

  end
end