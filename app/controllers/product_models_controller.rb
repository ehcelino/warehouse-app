class ProductModelsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_product_model, only: [:show, :edit, :update]

  def index
    @product_models = ProductModel.all
  end

  def new
    @product_model = ProductModel.new
    @suppliers = Supplier.all
  end

  def create
    @product_model = ProductModel.new(product_model_params)
    if @product_model.save
      redirect_to @product_model, notice: 'Modelo de Produto cadastrado com sucesso.'
    else
      @suppliers = Supplier.all
      flash.now[:notice] = "Não foi possivel cadastrar o modelo de produto."
      render :new
    end
  end

  def show
  end

  def edit
    @suppliers = Supplier.all
  end

  def update
    if @product_model.update(product_model_params)
      redirect_to product_models_path
    else
      @suppliers = Supplier.all
      render :edit
    end
  end

  private

  def product_model_params
    params.require(:product_model).permit(:name, :weight, :width, :height, :depth, :sku, :supplier_id)
  end

  def set_product_model
    @product_model = ProductModel.find(params[:id])
  end

end
