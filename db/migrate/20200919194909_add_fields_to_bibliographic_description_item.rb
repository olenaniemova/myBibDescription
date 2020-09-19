class AddFieldsToBibliographicDescriptionItem < ActiveRecord::Migration[6.0]
  def change
    add_column :bibliographic_description_items, :publishing_house, :string
    add_column :bibliographic_description_items, :subtitle, :string
    add_column :bibliographic_description_items, :number_of_publication, :integer
    add_column :bibliographic_description_items, :place, :string
    add_column :bibliographic_description_items, :ed, :string
    add_column :bibliographic_description_items, :url, :string
    remove_column :bibliographic_description_items, :publisher
  end
end
