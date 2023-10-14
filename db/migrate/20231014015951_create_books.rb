class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name, unique: true
      t.float :price
      t.boolean :owned
      t.string :availability
      t.string :book_number
      t.string :buy_url
      t.string :image_url
      t.references :series, null: true , foreign_key: true
      t.references :collection, null: true , foreign_key: true

      t.timestamps
    end
  end
end
