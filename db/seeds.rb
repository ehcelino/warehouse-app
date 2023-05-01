# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


vincent = User.create!(name:'Vincent', email: 'vincent@email.com', password: '12345678')
joao = User.create!(name:'João', email: 'joao@email.com', password: 'password')
marcos = User.create!(name:'Marcos', email: 'marcos@email.com', password: 'password')
warehouse = Warehouse.create!(name: 'Pouso Alegre Central', code: 'PSA', city: 'Pouso Alegre', state: 'MG', area: 100_000,
                              address: 'Avenida José de Moraes, 1000', cep: '37570-000',
                              description: 'Galpão sul de minas')
w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                      address: 'Avenida do Aeroporto, 1000', cep: '15000-000', state: 'SP',
                      description: 'Galpão destinado para cargas internacionais')
supplier = Supplier.create!(corporate_name: 'Geonav LTDA', brand_name: 'Geonav', registration_number: '1244563874125',
                           full_address: 'Av Central, 1000', city: 'Manaus', state: 'AM', email: 'comercial@geonav.com.br')
formatted_date = I18n.localize(1.year.from_now.to_date)
order = Order.create!(user: joao, warehouse: w, supplier: supplier, estimated_delivery_date: formatted_date)
order_two = Order.create!(user: vincent, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)
product_tv = ProductModel.create!(name: 'TV 50 polegadas', weight: 8000, width: 150, height: 80, depth: 10,
                                  sku: 'TV50-GEONAV-XPT15000', supplier: supplier)
product_soundbar = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20,
                                            sku: 'SOUND71-SAMSUNG-NOI2', supplier: supplier)
product_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9, depth: 20,
                                        sku: 'NOTE-SAMSUNG-XPTO201', supplier: supplier)
6.times { StockProduct.create!(order: order_two, warehouse: warehouse, product_model: product_tv) }
2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_notebook) }
# 5.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_soundbar) }
OrderItem.create!(product_model: product_soundbar, order: order, quantity: 50)
OrderItem.create!(product_model: product_notebook, order: order, quantity: 30)
