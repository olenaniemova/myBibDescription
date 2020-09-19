require "rails_helper"

RSpec.describe BibliographicDescriptionItemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/bibliographic_description_items").to route_to("bibliographic_description_items#index")
    end

    it "routes to #new" do
      expect(get: "/bibliographic_description_items/new").to route_to("bibliographic_description_items#new")
    end

    it "routes to #show" do
      expect(get: "/bibliographic_description_items/1").to route_to("bibliographic_description_items#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/bibliographic_description_items/1/edit").to route_to("bibliographic_description_items#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/bibliographic_description_items").to route_to("bibliographic_description_items#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/bibliographic_description_items/1").to route_to("bibliographic_description_items#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/bibliographic_description_items/1").to route_to("bibliographic_description_items#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bibliographic_description_items/1").to route_to("bibliographic_description_items#destroy", id: "1")
    end
  end
end
