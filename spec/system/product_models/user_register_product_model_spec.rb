require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
  it 'com sucesso' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
                                full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    other_supplier = Supplier.create!(corporate_name: 'LG Eletrônicos LTDA', brand_name: 'LG', registration_number: '1234567890321',
      full_address: 'Av Ibirapuera, 1000', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV 32'
    fill_in 'Peso', with: 8000
    fill_in 'Largura', with: 70
    fill_in 'Altura', with: 45
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV32-SAMSUNG-XPT3009'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content('Modelo de Produto cadastrado com sucesso.')
    expect(page).to have_content('TV 32')
    expect(page).to have_content('Fornecedor: Samsung')
    expect(page).to have_content('SKU: TV32-SAMSUNG-XPT3009')
    expect(page).to have_content('Dimensão: 70 x 45 x 10 cm')
    expect(page).to have_content('Peso: 8000g')
  end

  it 'deve preencher todos os campos' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
      full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    other_supplier = Supplier.create!(corporate_name: 'LG Eletrônicos LTDA', brand_name: 'LG', registration_number: '1234567890321',
      full_address: 'Av Ibirapuera, 1000', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: ''
    fill_in 'Peso', with: 8000
    fill_in 'Largura', with: 70
    fill_in 'Altura', with: 45
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: ''
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'
    # Assert
    expect(page).to have_content('Não foi possivel cadastrar o modelo de produto.')
  end

  it 'e preenche o campo código com tamanho inválido' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
      full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    other_supplier = Supplier.create!(corporate_name: 'LG Eletrônicos LTDA', brand_name: 'LG', registration_number: '1234567890321',
      full_address: 'Av Ibirapuera, 1000', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV 32'
    fill_in 'Peso', with: 8000
    fill_in 'Largura', with: 70
    fill_in 'Altura', with: 45
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV32-SAMSUNG-XPT300'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'
    # Assert
    expect(page).to have_content('Não foi possivel cadastrar o modelo de produto.')
    expect(page).to have_content('SKU não possui o tamanho esperado (20 caracteres)')
  end

  it 'e preenche os campos de dimensões com valores inválidos' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
      full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    other_supplier = Supplier.create!(corporate_name: 'LG Eletrônicos LTDA', brand_name: 'LG', registration_number: '1234567890321',
      full_address: 'Av Ibirapuera, 1000', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV 32'
    fill_in 'Peso', with: 0
    fill_in 'Largura', with: 0
    fill_in 'Altura', with: 0
    fill_in 'Profundidade', with: 0
    fill_in 'SKU', with: 'TV32-SAMSUNG-XPT3009'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'
    # Assert
    expect(page).to have_content('Não foi possivel cadastrar o modelo de produto.')
    expect(page).to have_content('Peso deve ser maior que 0')
    expect(page).to have_content('Largura deve ser maior que 0')
    expect(page).to have_content('Altura deve ser maior que 0')
    expect(page).to have_content('Profundidade deve ser maior que 0')
  end

end
