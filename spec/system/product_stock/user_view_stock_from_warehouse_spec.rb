require 'rails_helper'

describe 'Usuário vê o estoque' do
  it 'na tela do galpão' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000', state: 'SP',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
      full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                      sku: 'TV32-SAMSUNG-XPT3009', supplier: supplier)
    product_soundbar = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20,
                                            sku: 'SOUND71-SAMSUNG-NOI2', supplier: supplier)
    product_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9, depth: 20,
                                            sku: 'NOTE-SAMSUNG-XPTO201', supplier: supplier)
    3.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_notebook) }

    # Act
    login_as(user)
    visit root_path
    click_on('Aeroporto SP')

    # Assert
    within("section#stock_products") do
      expect(page).to have_content 'Itens em Estoque'
      expect(page).to have_content '3 x TV32-SAMSUNG-XPT3009'
      expect(page).to have_content '2 x NOTE-SAMSUNG-XPTO20'
      expect(page).not_to have_content 'SOUND71-SAMSUNG-NOI2'
    end
  end

  it 'e dá baixa em um item' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000', state: 'SP',
      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletrônicos LTDA', brand_name: 'Samsung', registration_number: '1234567890123',
      full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                      sku: 'TV32-SAMSUNG-XPT3009', supplier: supplier)
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }

    # Act
    login_as user
    visit root_path
    click_on 'Aeroporto SP'
    select 'TV32-SAMSUNG-XPT3009', from: 'Item para Saída'
    fill_in 'Destinatário', with: 'Maria Ferreira'
    fill_in 'Endereço Destino', with: 'Rua das Palmeiras, 100 - Campinas - São Paulo'
    click_on 'Confirmar Retirada'

    # Assert
    expect(current_path).to eq warehouse_path(w.id)
    expect(page).to have_content 'Item retirado com sucesso'
    expect(page).to have_content '1 x TV32-SAMSUNG-XPT3009'

  end

end
