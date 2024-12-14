class SubUser < ApplicationRecord
    # #rolify 이용하기 위한 
    # resourcify
    #fast json
    # attr_accessor :id, :user_name, :profile_image, :birth_date, :drink, :smoke, :caffeine, :sex

    belongs_to :user
    #이용자 정보 등록하기
    #가족력
    has_many :family_med_histories
    has_many :med_his, :through => :family_med_histories, dependent: :destroy
    #과거 병력
    has_many :past_diseases
    has_many :past_disease, :through => :past_diseases, dependent: :destroy
    #현재 앓고 있는 질환
    has_many :current_diseases
    has_many :current_disease, :through => :current_diseases, dependent: :destroy
    #과거 약물 이력
    has_many :past_drugs
    has_many :past_drug, :through => :past_drugs, dependent: :destroy
    #현재 약물 이력
    has_many :current_drugs
    has_many :current_drug, :through => :current_drugs, dependent: :destroy
    #과거 건강기능식품 복용 내역
    has_many :past_supplements
    has_many :past_sup, :through => :past_supplements, :source => :past_supplement, dependent: :destroy
    #현재 복용중인 건강기능식품
    has_many :current_supplements
    has_many :current_sup, :through => :current_supplements, :source => :current_supplement, dependent: :destroy

end
