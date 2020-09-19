class CreateBibliographicDescriptionItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bibliographic_description_items do |t|
      t.string :title
      t.integer :year
      t.string :publisher
      t.references :source_style, null: false, foreign_key: true

      t.timestamps
    end
  end
end
