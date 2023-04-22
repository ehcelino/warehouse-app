require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Remover'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão excluído com sucesso.'
    expect(page).not_to have_content 'Rio'
    expect(page).not_to have_content 'SDU'
  end

  it 'e não apaga outros galpões' do
    # Arrange
    first_warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    second_warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CUI', city: 'Cuiabá', area: 80_000,
      address: 'Av central, 1000', cep: '43000-000', description: 'Galpão centro da cidade')
    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Remover'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão excluído com sucesso.'
    expect(page).not_to have_content 'Rio'
    expect(page).not_to have_content 'SDU'
    expect(page).to have_content 'Cuiabá'
  end
end