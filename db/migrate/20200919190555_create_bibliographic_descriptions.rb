class CreateBibliographicDescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :bibliographic_descriptions do |t|
      t.string :title
      t.string :description
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
