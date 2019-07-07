class User::CurrentDiseasesController < ApplicationController
  before_action :authenticate_request!
  before_action :set_current_disease, :search_id, only: [:create, :show, :update, :destroy, :destroy_to_past]
  before_action :update_current_disease, only: [:update]
  before_action :id_to_modify, only: [:update, :destroy, :destroy_to_past]

  # GET /current_diseases
  def index
    @current_diseases = CurrentDisease.all

    render json: @current_diseases
  end

  # GET /current_diseases/1
  def show
    render json: @current_disease
  end

  # POST /current_diseases
  def create
    if @current_disease.include?(Disease.find(@search_id))
      render json: { errors: "이미 앓고 있는 질환입니다." }, status: :unprocessable_entity
    elsif @current_disease << Disease.find(@search_id)
      set_time_memo = CurrentDisease.where(user_info_id: params[:user_info_id], current_disease_id: @search_id).last
      set_time_memo.update(from: params[:from] ? params[:from] : Time.zone.now, to: params[:to])
      render json: @current_disease, status: :created
    else
      render json: @current_disease.errors, status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /current_diseases/1
  def update
    if @current_disease.update(@current_disease_params)
      render json: @current_disease
    else
      render json: @current_disease.errors, status: :unprocessable_entity
    end
  end

  # DELETE /current_diseases/1
  def destroy
    CurrentDisease.find(@id_to_modify).delete
  end

  def destroy_to_past
    selected = CurrentDisease.find(@id_to_modify)
    CurrentDisease.find(@id_to_modify).delete
    @user_info =  UserInfo.find(params[:user_info_id])
    @user_info.past_disease << selected.current_disease
    @user_info.past_diseases.order("created_at").last.update(from: selected.from, to: params[:to] ? params[:to] : Time.zone.now)
    render json: @user_info.past_diseases
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_disease
      if current_user.has_role? "admin"
        @current_disease = UserInfo.find(params[:user_info_id]).current_disease
      else
        if current_user.user_info_ids.include? params[:user_info_id].to_i
          @current_disease = UserInfo.find(params[:user_info_id]).current_disease
        else
          render json: { errors: "잘못된 접근입니다." }, status: :bad_request
          return
        end
      end
    end

    # def set_result
    #   @result = []
    #   UserInfo.find(params[:user_info_id]).current_diseases.each { |d|
    #     @result << { id: d.id, parent_id: d.current_disease.id, name: d.current_disease.name, from: d.from, to: d.to }
    #   }
    # end

    def update_current_disease
      @current_disease_params = params.permit(:from, :to)
      if (current_user.has_role? "admin") || (current_user.user_info_ids.include? params[:user_info_id].to_i)
        @current_disease = UserInfo.find(params[:user_info_id]).current_diseases.find(params[:id])
      end
    end

    def id_to_modify
      @id_to_modify = params[:id]
    end


    def search_id
      @search_id = params[:search_id]
    end
    
end
