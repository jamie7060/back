class User::SubUsersController < ApplicationController
  before_action :authenticate_request!
  before_action :set_sub_user, only: [:show, :update, :destroy]

  # GET /sub_users
  # def index
  #   @sub_users = SubUser.all

  #   render json: @sub_users
  # end

  # GET /sub_users/1
  def show
    render json: SubUserSerializer.new(SubUser.find(params[:id])).serialized_json
  end

  # POST /sub_users
  def create
    require 'payload'

    @sub_user= SubUser.new(sub_user_params)
    @sub_user.user = current_user
    if @sub_user.save
      render json: Payload.jwt_encoded(current_user), status: :created
    else
      render json: @sub_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sub_users/1
  def update
    require 'payload'

    if @sub_user.update(sub_user_params)
      render json: Payload.jwt_encoded(@sub_user.user)
    else
      render json: @sub_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sub_users/1
  def destroy
    @sub_user.destroy unless (current_user.sub_users.first == @sub_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_user
      if current_user.sub_user_ids.include? params[:id].to_i
        @sub_user = SubUser.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def sub_user_params
      params.permit(:user_name, :profile_image, :birth_date, :drink, :smoke, :caffeine, :sex)
    end
end
