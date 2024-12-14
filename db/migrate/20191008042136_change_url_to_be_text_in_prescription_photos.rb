class ChangeUrlToBeTextInPrescriptionPhotos < ActiveRecord::Migration[5.2]
  def change
    change_column :prescription_photos, :url, :text
  end
end
