class SupplementIngrSerializer
  include FastJsonapi::ObjectSerializer
  attributes :ingr_name, :benefits, :rich_foods, :active_ingr
  has_many :rankings, serializer: SupplementIngrsSupplementSerializer
end
