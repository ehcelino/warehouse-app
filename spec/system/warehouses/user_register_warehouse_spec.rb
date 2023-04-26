require 'rails_helper'

describe 'Usuário cadastra um galpão' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path
    click_on 'Cadastrar Galpão'

    # Assert
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Código')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Área')

  end

  it 'Com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: 'Rio de Janeiro'
    fill_in 'Descrição', with: 'Galpão da zona portuária do Rio'
    fill_in 'Código', with: 'RIO'
    fill_in 'Endereço', with: 'Avenida do Museu do Amanhã, 1000'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'CEP', with: '20100-000'
    fill_in 'Área', with: '32000'
    click_on 'Enviar'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Galpão cadastrado com sucesso.')
    expect(page).to have_content('Rio de Janeiro')
    expect(page).to have_content('RIO')
    expect(page).to have_content('32000 m2')

  end

  it 'com dados incompletos' do
    # Arrange

    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'CEP', with: ''
    fill_in 'Área', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Galpão não cadastrado.")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Código não pode ficar em branco")
    expect(page).to have_content("Endereço não pode ficar em branco")
    expect(page).to have_content("Cidade não pode ficar em branco")
    expect(page).to have_content("Estado não pode ficar em branco")
    expect(page).to have_content("CEP não pode ficar em branco")
    expect(page).to have_content("Área não pode ficar em branco")
    expect(page).to have_content("CEP deve ser no formato xxxxx-xxx")
  end

  it 'com CEP errado' do

    # Arrange

    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: 'Rio de Janeiro'
    fill_in 'Descrição', with: 'Galpão da zona portuária do Rio'
    fill_in 'Código', with: 'RIO'
    fill_in 'Endereço', with: 'Avenida do Museu do Amanhã, 1000'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'CEP', with: '20100000'
    fill_in 'Área', with: '32000'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("CEP deve ser no formato xxxxx-xxx")
  end

  it 'com nome e código duplicado' do

    # Arrange
    Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', state: 'SP', area: 100_000,
      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais')
    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: 'Aeroporto SP'
    fill_in 'Descrição', with: 'Galpão destinado para cargas internacionais'
    fill_in 'Código', with: 'GRU'
    fill_in 'Endereço', with: 'Avenida do Aeroporto, 1000'
    fill_in 'Cidade', with: 'Guarulhos'
    fill_in 'Estado', with: 'SP'
    fill_in 'CEP', with: '15000-000'
    fill_in 'Área', with: '100000'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content("Nome já está em uso")
    expect(page).to have_content("Código já está em uso")
  end

end
