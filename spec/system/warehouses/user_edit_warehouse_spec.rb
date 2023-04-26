require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
                    address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    # Assert
    expect(page).to have_content 'Editar Galpão'
    expect(page).to have_field('Nome', with: 'Rio')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Código', with: 'SDU')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade', with: 'Rio de Janeiro')
    expect(page).to have_field('Estado', with: 'RJ')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Área')
  end

  it 'com sucesso' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
                    address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fill_in 'Nome', with: 'Galpão Internacional'
    fill_in 'Área', with: '100000'
    fill_in 'CEP', with: '20000-300'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Galpão atualizado com sucesso.'
    expect(page).to have_content 'Galpão Internacional'
    expect(page).to have_content 'Área: 100000 m2'
    expect(page).to have_content 'CEP: 20000-300'
  end

  it 'e mantém os campos obrigatórios' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
                    address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fill_in 'Nome', with: 'Galpão Internacional'
    fill_in 'Área', with: '100000'
    fill_in 'CEP', with: '20000-300'
    fill_in 'Endereço', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Galpão não atualizado.'
  end
end
