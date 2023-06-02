require 'rails_helper'

describe 'Warehouse API' do
  context 'GET /api/v1/warehouse/1' do
    it 'success' do
      # Arrange
      w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                            address: 'Avenida do Aeroporto, 1000', cep: '15000-000', state: 'SP',
                            description: 'Galpão destinado para cargas internacionais')

      # Act
      get "/api/v1/warehouses/#{w.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response['name']).to eq('Aeroporto SP')
      expect(json_response['code']).to eq('GRU')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')

    end

    it 'fail if warehouse not found' do
      # Arrange

      # Act
      get "/api/v1/warehouses/999999"

      # Assert
      expect(response.status).to eq 404
    end

  end

  context 'GET /api/v1/warehouses' do
    it 'success and ordered by name' do
      # Arrange
      Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
        address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      Warehouse.create!(name: 'Cuiabá', code: 'CUI', city: 'Cuiabá', state: 'MT', area: 80_000,
        address: 'Av central, 1000', cep: '43000-000', description: 'Galpão centro da cidade')
      # Act
      get '/api/v1/warehouses'
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Cuiabá'
      expect(json_response[1]['name']).to eq 'Rio'

    end

    it 'returns empty' do
      # Arrange
      # Act
      get '/api/v1/warehouses'
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'and raise internal error' do
      # Arrange
      allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      # Act
      get '/api/v1/warehouses'
      # Assert
      expect(response).to have_http_status(500)
    end

  end

  context 'POST /api/v1/warehouses' do
    it 'success' do
      # Arrange
      warehouse_params = { warehouse: { name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
        address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio' } }
      # Act
      post '/api/v1/warehouses', params: warehouse_params
      # Assert
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq 'Rio'
      expect(json_response['code']).to eq 'SDU'
      expect(json_response['city']).to eq 'Rio de Janeiro'
      expect(json_response['state']).to eq 'RJ'
      expect(json_response['area']).to eq 60000
    end

    it 'fail if parameters are not complete' do
      # Arrange
      warehouse_params = { warehouse: { code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
        address: 'Av do Porto, 1000', cep: '20000-000' } }
      # Act
      post '/api/v1/warehouses', params: warehouse_params
      # Assert
      expect(response).to have_http_status(412)
      expect(response.body).to include 'Nome não pode ficar em branco'
      expect(response.body).not_to include 'Cidade não pode ficar em branco'
    end

    it 'fails if there is an internal error' do
      # Arrange
      allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
      warehouse_params = { warehouse: { name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', state: 'RJ', area: 60_000,
        address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio' } }

      # Act
      post '/api/v1/warehouses', params: warehouse_params

      # Assert
      expect(response).to have_http_status(500)
    end
  end

  context 'patch /api/v1/warehouses' do
    it 'works' do
      # Arrange
      warehouse_original = { warehouse: {name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                            address: 'Av. do Porto, 1000', state: 'RJ', cep: '20000-000',
                            description: 'Galpão do Rio'}
      }
      post '/api/v1/warehouses', params: warehouse_original
      original_warehouse_id = JSON.parse(response.body)["id"]

      # Act
      patch "/api/v1/warehouses/#{original_warehouse_id}", params: { warehouse: { name: 'Galpão Rio'} }

      # Assert
      expect(response).to have_http_status(201)
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq 'Galpão Rio'
    end

    it 'fails to patch' do
      # Arrange
      warehouse_original = { warehouse: {name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                            address: 'Av. do Porto, 1000', state: 'RJ', cep: '20000-000',
                            description: 'Galpão do Rio'}
      }
      post '/api/v1/warehouses', params: warehouse_original
      original_warehouse_id = JSON.parse(response.body)["id"]
      warehouse = instance_double(Warehouse)
      allow(Warehouse).to receive(:find).and_return(warehouse)
      allow(warehouse).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)
      # allow_any_instance_of(Warehouse).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)

      # Act
      patch "/api/v1/warehouses/#{original_warehouse_id}", params: { warehouse: { name: 'Galpão Rio'} }

      # Assert
      expect(response.status).to eq 500

    end
  end
end
