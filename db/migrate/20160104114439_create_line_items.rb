class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product
      t.belongs_to :cart, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
