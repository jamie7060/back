class User::MypageController < ApplicationController
  before_action :authenticate_request!
  before_action :set_sub_user, only: [:create, :update, :destroy]

  def test
    user = current_user
    options = {}
    options[:include] = [:sub_users]

    render json: UserSerializer.new(user, options).serialized_json
  end

  def create
    @sub_user = current_user.sub_users.create(sub_user_params)

    if @sub_user.save
      render json: @sub_user, status: :created, location: @sub_user
    else
      render json: @sub_user.errors, status: :unprocessable_entity
    end 
  end

  def index
    require 'review_view'

    sub_users = current_user.sub_users
    @data_sent = Hash.new
    infos = []
    #나의 리뷰 목록
    my_reviews = current_user.drug_reviews
    sub_users.each { |sub_user|
      #각각의 이력 정렬
      @past_diseases = []
      sub_user.past_diseases.each { |d|
        @past_diseases << { id: d.id, parent_id: d.past_disease.id, name: d.past_disease.name, from: d.from, to: d.to }
      }
      @current_diseases = []
      sub_user.current_diseases.each { |d|
        @current_diseases << { id: d.id, parent_id: d.current_disease.id, name: d.current_disease.name, from: d.from, to: d.to }
      }
      
      @past_drugs = PastDrugSerializer.new(sub_user.past_drugs, {params: {current_user: current_user}})
      @current_drugs = CurrentDrugSerializer.new(sub_user.current_drugs, {params: {current_user: current_user}})

      @past_supplements = []
      sub_user.past_supplements.each { |d|
        @past_supplements << { id: d.id, parent_id: d.past_supplement.id, name: d.past_supplement.name, from: d.from, to: d.to, memo: d.memo  }
      }
      @current_supplements = []
      sub_user.current_supplements.each { |d|
        @current_supplements << { id: d.id, parent_id: d.current_supplement.id, name: d.current_supplement.name, from: d.from, to: d.to, memo: d.memo  }
      }
      info_data = { sub_user: { basic_info: sub_user, family_med_his: sub_user.med_his.select(:id, :name), past_diseases: @past_diseases, 
      current_diseases: @current_diseases, 
      past_drugs: @past_drugs, 
      current_drugs: @current_drugs,
      past_supplements: @past_supplements,
      current_supplements: @current_supplements }
      }
      #각각의 데이터를 넣어줌
      infos << info_data
    }
    @data_sent[:infos] = infos
    @data_sent[:watch_drugs] = DrugSerializer.new(current_user.watch_drug)
    @data_sent[:watch_supplements] = current_user.watch_supplement
    @data_sent[:drug_reviews] = DrugReviewSerializer.new(my_reviews, {params: {liked_drug_reviews: current_user.l_drug_review_ids}})
    @data_sent[:sup_reviews] = current_user.sup_reviews
    
    render json: @data_sent
  end

  def update
    if @sub_user.update(sub_user_params)
  end

  def destroy
    @sub_user.destroy
  end

  private

  def set_sub_user
    @sub_user = SubUser.find(params[:id])
  end

  def sub_user_params
    params.require([:sub_user]).permit(:id, :user_name, :profile_image, :birth_date, :drink, :smoke, :caffeine)
  end

  # def update_params
  #   params.require([:sub_user, :family_med_his, :past_disease, :current_disease, :past_drug, :current_drug, :past_supplement]).permit(:id, :profile_image, :birth_date, :drink, :smoke, :caffeine, :disease_name, :past_disease, :current_diseases, :past_supplement,:current_supplement)
  end

end
