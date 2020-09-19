class Author < ApplicationRecord
  has_and_belongs_to_many :bibliographic_description_item
end
