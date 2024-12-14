class User::PastDrugsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_past_drug, :search_id, only: [:create, :update, :destroy]
  before_action :set_past_drug_for_show, only: [:show]
  before_action :update_past_drug, only: [:update]
  before_action :id_to_modify, only: [:update, :destroy]

  # GET /past_drugs
  def index
    @past_drugs = PastDrug.all

    render json: @past_drugs
  end

  # GET /past_drugs/1
  def show
    render json: PastDrugSerializer.new(@past_drug_for_show, {params: {current_user: current_user}}).serialized_json
  end

  # POST /past_drugs
  def create
    require 'dur_analysis'

    drug_found = Drug.find(@search_id)

    if created = PastDrug.create(sub_user_id: @sub_user.id, past_drug_id: @search_id, from: params[:from], to: params[:to] ? params[:to] : Time.zone.now, memo: params[:memo], when: params[:when], how: params[:how])
      #dur 정보 추가
      dur_info = DurAnalysis.get_by_drug(DurAnalysis.drug_code([drug_found.id]))
      drug_found.dur_info = dur_info unless dur_info.nil?
      drug_found.save
      begin
        disease = Disease.find_or_create_by(name: params[:disease_name])
        #먹는 이유 추가하기(질환추가)
        created.diseases << disease unless disease.blank?
      end
      render json: @past_drug.pluck(:id, :name), status: :created
    else
      render json: @past_drug.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /past_drugs/1
  def update
    if @past_drug.update(@past_drug_params)
      render json: @past_drug
    else
      render json: @past_drug.errors, status: :unprocessable_entity
    end
  end

  # DELETE /past_drugs/1
  def destroy
    if PastDrug.find(@id_to_modify).destroy
      render json: @past_drug, status: 200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_past_drug
      if current_user.has_role? "admin"
        @sub_user = SubUser.find(params[:sub_user_id])
        @past_drug = @sub_user.past_drug
      else
        if current_user.sub_user_ids.include? params[:sub_user_id].to_i
          @sub_user = SubUser.find(params[:sub_user_id])
          @past_drug = @sub_user.past_drug
        else
          render json: { errors: "잘못된 접근입니다." }, status: :bad_request
          return
        end
      end
    end

    def set_past_drug_for_show
      if current_user.has_role? "admin"
        @sub_user = SubUser.find(params[:sub_user_id])
        @past_drug_for_show = @sub_user.past_drugs
      else
        if current_user.sub_user_ids.include? params[:sub_user_id].to_i
          @sub_user = SubUser.find(params[:sub_user_id])
          @past_drug_for_show = @sub_user.past_drugs
        else
          render json: { errors: "잘못된 접근입니다." }, status: :bad_request
          return
        end
      end
    end

    def update_past_drug
      @past_drug_params = params.permit(:from, :to, :memo, :when, :how)
      if current_user.sub_user_ids.include? params[:sub_user_id].to_i
        @past_drug = SubUser.find(params[:sub_user_id]).past_drugs.find(params[:id])
      end
    end

    def id_to_modify
      @id_to_modify = params[:id]
    end


    def search_id
      @search_id = params[:search_id]
    end

end
