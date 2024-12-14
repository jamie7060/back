class Drug < ApplicationRecord
  require 'json'
    
    def kor_map(enumerable)
      result = []
      if(!enumerable.nil?)
          JSON.parse(enumerable).each do |element| 
          element.nil? ? next : result.push(*(element))
          end
      end
      result
    end

    def eng_map(enumerable)
      if(!enumerable.nil?)
          a = JSON.parse(enumerable)
      end
      a
    end

  resourcify
  
  # has_and_belongs_to_many :dur_ingrs
  has_one :drug_imprint
  has_many :pasts, :class_name => "PastDrug", :foreign_key => "past_drug_id"
  has_many :currents, :class_name => "CurrentDrug", :foreign_key => "current_drug_id"
  has_many :watch_drugs, :class_name => "WatchDrug", :foreign_key => "watch_drug_id"
  has_many :watch_supplements, :class_name => "WatchSupplement", :foreign_key => "watch_supplement_id"
  #리뷰
  has_many :reviews, :class_name => "DrugReview"
  
  #약 성분 연결(join table 통해서)
  has_many :drug_associations
  has_many :drug_ingrs, through: :drug_associations
  has_many :interactions, through: :drug_ingrs
  has_and_belongs_to_many :dur_ingrs, join_table: "drug_associations", foreign_key: "drug_id", association_foreign_key: "dur_ingr_id"

  searchkick language: "korean", word_start: [:name], word_middle: [:name, :ingr_kor_name, :ingr_eng_name], word: [:name]

  def search_data
      {
          name: name,
          ingr_kor_name: kor_map(ingr_kor_name),
          ingr_eng_name: eng_map(ingr_eng_name),
          item_seq: item_seq,
      }
  end

end
