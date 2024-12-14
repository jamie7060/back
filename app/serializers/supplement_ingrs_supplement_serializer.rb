class SupplementIngrsSupplementSerializer
  include FastJsonapi::ObjectSerializer
  attribute :ranking
  attribute :ingr_name do |object|
    object.supplement_ingr.ingr_name
  end
end
