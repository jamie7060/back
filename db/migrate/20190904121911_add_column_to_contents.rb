class AddColumnToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :category, :string, before: :title
  end
end
