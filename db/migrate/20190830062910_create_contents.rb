class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :thumbnail_url
      t.text :body

      t.timestamps
    end
  end
end
