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

  it 'com CNPJ inválido' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: 'Amazonas'
    fill_in 'Razão Social', with: 'Amazonas LTDA'
    fill_in 'CNPJ', with: '123456789012'
    fill_in 'Endereço', with: 'Av Central, 1000'
    fill_in 'Cidade', with: 'Manaus'
    fill_in 'Estado', with: 'AM'
    fill_in 'E-mail', with: 'comercial@amazonas.com'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Fornecedor não cadastrado.")
    expect(page).to have_content("CNPJ não possui o tamanho esperado (13 caracteres)")

  end

  it 'com duplicação do CNPJ' do
    # Arrange
    Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                    full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: 'Panasonic'
    fill_in 'Razão Social', with: 'Panasonic LTDA'
    fill_in 'CNPJ', with: '1234567890123'
    fill_in 'Endereço', with: 'Av Principal, 1000'
    fill_in 'Cidade', with: 'Manaus'
    fill_in 'Estado', with: 'AM'
    fill_in 'E-mail', with: 'sac@panasonic.com'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Fornecedor não cadastrado.")
    expect(page).to have_content("CNPJ já está em uso")

  end

  it 'e esquece alguns campos' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: 'Av Central, 1000'
    fill_in 'Cidade', with: 'Manaus'
    fill_in 'Estado', with: 'AM'
    fill_in 'E-mail', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Fornecedor não cadastrado.")
    expect(page).to have_content("Razão Social não pode ficar em branco")
    expect(page).to have_content("Nome Fantasia não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("E-mail não pode ficar em branco")
    expect(page).to have_content("CNPJ não possui o tamanho esperado (13 caracteres)")

  end

end
