class CreateHealthNews < ActiveRecord::Migration[5.2]
  def change
    create_table :health_news do |t|
      t.string :url
      t.string :press

      t.timestamps
    end
  end
end
