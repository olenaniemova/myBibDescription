class BibliographicDescription < ApplicationRecord
  belongs_to :profile
  has_and_belongs_to_many :bibliographic_description_items
end
