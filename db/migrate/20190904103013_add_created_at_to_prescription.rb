class AddCreatedAtToPrescription < ActiveRecord::Migration[5.2]
  def change
    add_column :prescription_photos, :created_at, :datetime, null: false, default: Time.zone.now
  end
end
