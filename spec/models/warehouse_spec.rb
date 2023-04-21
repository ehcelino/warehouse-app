require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  city: 'Rio de Janeiro', cep: '20100-000', area: '32000')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      it 'false when code is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Avenida do Museu do Amanhã, 1000',
                                  city: 'Rio de Janeiro', cep: '20100-000', area: '32000')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      it 'false when address is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '',
                                  city: 'Rio de Janeiro', cep: '20100-000', area: '32000')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      it 'false when city is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  city: '', cep: '20100-000', area: '32000')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      it 'false when cep is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  city: 'Rio de Janeiro', cep: '', area: '32000')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      it 'false when area is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  city: 'Rio de Janeiro', cep: '20100-000', area: '')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
    end
    it 'false when code is already in use' do
      # Arrange
      first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
        city: 'Rio de Janeiro', cep: '20100-000', area: '32000')
      second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
        city: 'Rio de Janeiro', cep: '20100-000', area: '32000')
      # Act
        result = second_warehouse.valid?
      # Assert
        expect(result).to eq false
    end
  end
end
