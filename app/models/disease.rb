class Disease < ApplicationRecord
    resourcify
    has_many :histories, :class_name => "FamilyMedHistory", :foreign_key => "med_his_id"
    has_many :pasts, :class_name => "PastDisease", :foreign_key => "past_disease_id"
    has_many :currents, :class_name => "CurrentDisease", :foreign_key => "current_disease_id"
    has_many :drug_taking_reasons
    validates_uniqueness_of :name
end
