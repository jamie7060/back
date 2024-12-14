class AddRatingToDrugs < ActiveRecord::Migration[5.2]
  def change
    add_column :drugs, :drug_rating, :float, default: nil
  end
end
