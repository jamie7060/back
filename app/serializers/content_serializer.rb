class ContentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :category, :title, :body
  attribute :thumbnail_url do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.thumbnail_image) if object.thumbnail_image.attached?
  end
end
