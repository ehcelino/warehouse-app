require 'rails_helper'
include ActionView::RecordIdentifier

describe 'Usuário vê modelos de produtos' do
  it 'e edita um modelo de produto com sucesso' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
                                 full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    model = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                sku: 'TV32-SAMSUNG-XPT3009', supplier: supplier)
    id = dom_id(model)

    # Act
    login_as user
    visit product_models_path
    find(:css, "##{id}").click
    fill_in 'Nome', with: 'TV Samsung 32'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'TV Samsung 32'
  end

  it 'e edita um modelo de produto com campo em branco' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
                                 full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    model = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                sku: 'TV32-SAMSUNG-XPT3009', supplier: supplier)
    id = dom_id(model)

    # Act
    login_as user
    visit product_models_path
    find(:css, "##{id}").click
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end
