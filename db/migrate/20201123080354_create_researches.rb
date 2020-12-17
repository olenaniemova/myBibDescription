class CreateResearches < ActiveRecord::Migration[6.0]
  def change
    create_table :researches do |t|
      t.string :text
      t.boolean :correctness
      t.string :style
      t.string :source
      t.string :defined_style, null: true
      t.string :defined_source, null: true

      t.timestamps
    end
  end
end
