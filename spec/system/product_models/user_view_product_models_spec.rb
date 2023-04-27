require 'rails_helper'

describe 'Usuário vê modelos de produtos' do

  it 'se estiver autenticado' do
    # Arrange

    # Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end
    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
  end
  it 'com sucesso' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
                                 full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                        sku: 'TV32-SAMSUNG-XPT3009', supplier: supplier)
    ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20,
                        sku: 'SOUND71-SAMSUNG-NOI2', supplier: supplier)

    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content('TV 32')
    expect(page).to have_content('TV32-SAMSUNG-XPT3009')
    expect(page).to have_content('Samsung')
    expect(page).to have_content('SoundBar 7.1 Surround')
    expect(page).to have_content('SOUND71-SAMSUNG-NOI2')
    expect(page).to have_content('Samsung')
  end

  it 'e não existem produtos cadastrados' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content('Nenhum modelo de produto cadastrado.')
  end

end
