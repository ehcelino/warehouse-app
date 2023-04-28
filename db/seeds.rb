# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


vincent = User.create!(name:'Vincent', email: 'vincent@email.com', password: '12345678')
User.create!(name:'Marcos', email: 'marcos@email.com', password: 'password')
warehouse = Warehouse.create!(name: 'Pouso Alegre Central', code: 'PSA', city: 'Pouso Alegre', state: 'MG', area: 100_000,
                              address: 'Avenida José de Moraes, 1000', cep: '37570-000',
                              description: 'Galpão sul de minas')
supplier = Supplier.create!(corporate_name: 'Geonav LTDA', brand_name: 'Geonav', registration_number: '1244563874125',
                           full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@geonav.com.br')
ProductModel.create!(name: 'TV 50 polegadas', weight: 8000, width: 150, height: 80, depth: 10,
                            sku: 'TV50-GEONAV-XPT15000', supplier: supplier)
formatted_date = I18n.localize(1.year.from_now.to_date)
order = Order.create!(user: vincent, warehouse: warehouse, supplier: supplier, estimated_delivery_date: formatted_date)
