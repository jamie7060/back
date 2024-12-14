class PrescriptionPhoto < ApplicationRecord
    has_one_attached :photo

    validates :photo, attached: true, content_type: [:png, :jpg, :jpeg], size: { less_than: 100.megabytes , message: 'is not given between size' }

end
