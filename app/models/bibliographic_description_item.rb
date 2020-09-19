class BibliographicDescriptionItem < ApplicationRecord
  belongs_to :source_style
  has_and_belongs_to_many :bibliographic_descriptions
  has_and_belongs_to_many :authors
end
