class SupplementsController < ApplicationController
  before_action :set_supplement, only: [:show, :update, :destroy]

  # GET /supplements
  def index
    supplements_found = SupplementIngr.find(params[:supplement_ingr_id]).supplements.where(shopping_site: params[:shopping_site]).includes(:rankings).order("supplement_ingrs_supplements.ranking asc")
    @supplements = SupplementSerializer.new(supplements_found.paginate(page: params[:page], per_page: 12), {params: {supplement_ingr_id: params[:supplement_ingr_id]}}).serialized_json
    #헤더에 total 갯수 넣어줌
    response.set_header('Total-Count', supplements_found.size)
    render json: @supplements
  end

  # GET /supplements/1
  def show
    render json: @supplement
  end

  # POST /supplements
  def create
    @supplement = Supplement.new(supplement_params)

    if @supplement.save
      render json: @supplement, status: :created, location: @supplement
    else
      render json: @supplement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /supplements/1
  def update
    if @supplement.update(supplement_params)
      render json: @supplement
    else
      render json: @supplement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /supplements/1
  def destroy
    @supplement.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplement
      @supplement = Supplement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def supplement_params
      params.require(:supplement).permit(:shopping_site, :name, :price, :product_url, :photo_url, :rating, :shoppingmall_reviews)
    end
end
