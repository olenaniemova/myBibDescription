require "rails_helper"

RSpec.describe BibliographicDescriptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/bibliographic_descriptions").to route_to("bibliographic_descriptions#index")
    end

    it "routes to #new" do
      expect(get: "/bibliographic_descriptions/new").to route_to("bibliographic_descriptions#new")
    end

    it "routes to #show" do
      expect(get: "/bibliographic_descriptions/1").to route_to("bibliographic_descriptions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/bibliographic_descriptions/1/edit").to route_to("bibliographic_descriptions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/bibliographic_descriptions").to route_to("bibliographic_descriptions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/bibliographic_descriptions/1").to route_to("bibliographic_descriptions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/bibliographic_descriptions/1").to route_to("bibliographic_descriptions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bibliographic_descriptions/1").to route_to("bibliographic_descriptions#destroy", id: "1")
    end
  end
end
