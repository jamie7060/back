class Supplement < ApplicationRecord
  has_and_belongs_to_many :supplement_ingrs
  has_many :rankings, :class_name => "SupplementIngrsSupplement", dependent: :destroy
  validates_uniqueness_of :name, :scope => :shopping_site

end
