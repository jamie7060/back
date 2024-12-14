class AdverseEffectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :symptom_name
  # has_many :users, :through => :drug_reviews
end
