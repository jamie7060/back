class SupplementIngrsController < ApplicationController
  before_action :set_supplement_ingr, only: [:show, :update, :destroy]

  # GET /supplement_ingrs
  def index
    @supplement_ingrs = SupplementIngr.all

    render json: @supplement_ingrs
  end

  # GET /supplement_ingrs/1
  def show
    render json: @supplement_ingr
  end

  # POST /supplement_ingrs
  def create
    @supplement_ingr = SupplementIngr.new(supplement_ingr_params)

    if @supplement_ingr.save
      render json: @supplement_ingr, status: :created, location: @supplement_ingr
    else
      render json: @supplement_ingr.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /supplement_ingrs/1
  def update
    if @supplement_ingr.update(supplement_ingr_params)
      render json: @supplement_ingr
    else
      render json: @supplement_ingr.errors, status: :unprocessable_entity
    end
  end

  # DELETE /supplement_ingrs/1
  def destroy
    @supplement_ingr.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplement_ingr
      @supplement_ingr = SupplementIngr.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def supplement_ingr_params
      params.require(:supplement_ingr).permit(:approval_no, :ingr_name, :enterprise_name, :benefits, :warnings, :daily_intake, :daily_intake_max, :daily_intake_min, :active_ingr)
    end
end
