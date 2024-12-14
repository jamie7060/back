class AutocompleteController < ApplicationController
  before_action :check_token!, only: [:disease, :adverse_effect]
  before_action :set_sub_user, only: [:disease]

  require 'json'


  def search
    name = Drug.select(:name).map(&:name)
    arr1 = []
    name.each do |x|
      b = {category: "의약품명", title: x}
      arr1 << b
    end
    @name = arr1
    dur1 = DurIngr.select(:ingr_eng_name).map(&:ingr_eng_name)
    arr2 = []
    dur1.each do |x|
      c = {category: "성분명(영문)", title: x}
      arr2 << c
    end
    dur2 = DurIngr.select(:ingr_kor_name).map(&:ingr_kor_name)
    arr3 = []
    dur2.each do |x|
      d = {category: "성분명(국문)", title: x}
      arr3 << d
    end
    dur3 = DurIngr.select(:related_ingr_kor_name).map(&:related_ingr_kor_name)
    arr4 = []
    dur3.each do |x|
      e = {category: "성분명(국문)", title: x}
      arr4 << e
    end
    sup = Supplement.select(:name).map(&:name)
    arr5 = []
    sup.each do |x|
      e = {category: "건강기능식품 제품명", title: x}
      arr5 << e
    end
    sup_ingr = SupplementIngr.select(:ingr_name).map(&:ingr_name)
    arr6 = []
    sup_ingr.each do |x|
      e = {category: "기능성원료(국문)", title: x}
      arr6 << e
    end
    search_terms = arr1
    @search_terms = search_terms.uniq

    render json: @search_terms
  end

  # def generate
  #   y = SearchTerm.find(2)
  #   y.diseases = Disease.select([:id, :disease_name]).to_json
  #   y.drugs = Drug.select([:id, :item_name]).to_json
  #   y.supplements = Supplement.select([:id, :product_name]).to_json
    
  #   puts y.diseases
  #   y.save
  # end

  def disease
    @disease_terms = Hash.new
    @disease_terms["standard_diseases"] = JSON.parse(SearchTerm.pluck(:diseases)[1])
    compiled = (@sub_user.current_disease.where("current_disease_id > 174")) + (@sub_user.past_disease.where("past_disease_id > 174")) unless @sub_user.blank?
    @disease_terms["my_diseases"] = compiled.uniq unless compiled.blank?
    
    render json: @disease_terms
  end

  def drug
    render json: SearchTerm.pluck(:drugs)[1]
  end

  def sup
    render json: SearchTerm.pluck(:supplements)[1]
  end

  def adverse_effect
    @adverse_effects = Hash.new
    @adverse_effects["standard_adverse_effects"] = AdverseEffect.limit(79)
    @adverse_effects["my_adverse_effects"] = current_user.adverse_effects.where("adverse_effect_id > 79") unless current_user.nil?
    
    render json: @adverse_effects
  end

  private

  def set_sub_user
    unless current_user.blank?
      if current_user.sub_user_ids.include? params[:sub_user_id].to_i
        @sub_user = SubUser.find(params[:sub_user_id])
      end
    end
  end

end
