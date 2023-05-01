require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'e vê os dados previamente cadastrados' do
    # Arrange
    User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    # Act
    visit root_path
    within('form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with:'password'
      click_on 'Entrar'
    end
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
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    # Act
    login_as(user)
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

  it 'com falha devido à duplicação do CNPJ' do
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
    click_on 'Amazonas'
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: 'Amazonas Brasil'
    fill_in 'Endereço', with: 'Av Central, 3000'
    fill_in 'E-mail', with: 'faleconosco@amazonas.com'
    fill_in 'CNPJ', with: '1234567890321'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Fornecedor não atualizado.")
    expect(page).to have_content("CNPJ já está em uso")
  end

  it 'com falha devido ao tamanho do CNPJ' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    Supplier.create!(corporate_name: 'Amazonas LTDA', brand_name: 'Amazonas', registration_number: '1234567890123',
                                full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@amazonas.com')

    # Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on 'Amazonas'
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: 'Amazonas Brasil'
    fill_in 'Endereço', with: 'Av Central, 3000'
    fill_in 'E-mail', with: 'faleconosco@amazonas.com'
    fill_in 'CNPJ', with: '123456789032'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Fornecedor não atualizado.")
    expect(page).to have_content("CNPJ não possui o tamanho esperado (13 caracteres)")
  end

end
