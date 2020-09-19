require "rails_helper"

RSpec.describe BibliographicStylesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/bibliographic_styles").to route_to("bibliographic_styles#index")
    end

    it "routes to #new" do
      expect(get: "/bibliographic_styles/new").to route_to("bibliographic_styles#new")
    end

    it "routes to #show" do
      expect(get: "/bibliographic_styles/1").to route_to("bibliographic_styles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/bibliographic_styles/1/edit").to route_to("bibliographic_styles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/bibliographic_styles").to route_to("bibliographic_styles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/bibliographic_styles/1").to route_to("bibliographic_styles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/bibliographic_styles/1").to route_to("bibliographic_styles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bibliographic_styles/1").to route_to("bibliographic_styles#destroy", id: "1")
    end
  end
end
