class AdverseEffectsController < ApplicationController
  before_action :set_adverse_effect, only: [:show, :update, :destroy]
  before_action :authenticate_request!, only: [:create, :update, :destroy]

  # GET /adverse_effects
  def index
    @adverse_effects = AdverseEffect.all

    render json: @adverse_effects
  end

  # GET /adverse_effects/1
  def show
    render json: @adverse_effect
  end

  # POST /adverse_effects
  def create
    if @adverse_effect = AdverseEffect.find_or_create_by(adverse_effect_params)
      render json: @adverse_effect, status: :created, location: @adverse_effect
    else
      render json: @adverse_effect.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /adverse_effects/1
  def update
    if @adverse_effect.update(adverse_effect_params)
      render json: @adverse_effect
    else
      render json: @adverse_effect.errors, status: :unprocessable_entity
    end
  end

  # DELETE /adverse_effects/1
  def destroy
    @adverse_effect.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adverse_effect
      @adverse_effect = AdverseEffect.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def adverse_effect_params
      params.require(:adverse_effect).permit(:symptom_name)
    end

    # def is_admin?
    #   if current_user.has_role? "admin"
    #     return
    #   else
    #     render json: { errors: ['접속 권한이 없습니다.'] }, status: :unauthorized
    #   end
    # end
end
