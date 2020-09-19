class CreateSourceStyles < ActiveRecord::Migration[6.0]
  def change
    create_table :source_styles do |t|
      t.string :title
      t.string :description
      t.string :schema
      t.references :source, null: false, foreign_key: true
      t.references :bibliographic_style, null: false, foreign_key: true

      t.timestamps
    end
  end
end
