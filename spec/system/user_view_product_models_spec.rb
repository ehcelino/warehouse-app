require 'rails_helper'

describe 'Usuário vê modelos de produtos' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
  end
  it 'com sucesso' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
                                 full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                        sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
    ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20,
                        sku: 'SOU71-SAMSU-NOI277', supplier: supplier)

    # Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content('TV 32')
    expect(page).to have_content('TV32-SAMSU-XPTO90')
    expect(page).to have_content('Samsung')
    expect(page).to have_content('SoundBar 7.1 Surround')
    expect(page).to have_content('SOU71-SAMSU-NOI277')
    expect(page).to have_content('Samsung')
  end

  it 'e não existem produtos cadastrados' do
    # Arrange

    # Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    # Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content('Nenhum modelo de produto cadastrado.')
  end
  
end