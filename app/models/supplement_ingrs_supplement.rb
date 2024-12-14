class SupplementIngrsSupplement < ApplicationRecord

  belongs_to :supplement
  belongs_to :supplement_ingr
  validates_uniqueness_of :ranking, :scope => [:supplement_id, :supplement_ingr_id]
end
