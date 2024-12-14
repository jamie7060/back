class SupplementSerializer
  include FastJsonapi::ObjectSerializer
  attributes :shopping_site, :name, :enterprise_name, :price, :product_url, :photo_url, :rating, :shoppingmall_reviews
  attribute :rankings do |sup, params|
    SupplementIngrsSupplementSerializer.new(sup.rankings.where(supplement_ingr_id: params[:supplement_ingr_id])).serialized_json
  end
end
