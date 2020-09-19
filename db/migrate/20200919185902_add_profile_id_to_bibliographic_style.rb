class AddProfileIdToBibliographicStyle < ActiveRecord::Migration[6.0]
  def change
    add_reference :bibliographic_styles, :profile, foreign_key: true
  end
end
