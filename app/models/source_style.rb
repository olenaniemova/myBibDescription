class SourceStyle < ApplicationRecord
  belongs_to :source
  belongs_to :bibliographic_style
end
