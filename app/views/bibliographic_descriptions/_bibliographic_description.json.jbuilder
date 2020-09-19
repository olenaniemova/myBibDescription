json.extract! bibliographic_description, :id, :title, :description, :profile_id, :created_at, :updated_at
json.url bibliographic_description_url(bibliographic_description, format: :json)
