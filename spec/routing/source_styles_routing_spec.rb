require "rails_helper"

RSpec.describe SourceStylesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/source_styles").to route_to("source_styles#index")
    end

    it "routes to #new" do
      expect(get: "/source_styles/new").to route_to("source_styles#new")
    end

    it "routes to #show" do
      expect(get: "/source_styles/1").to route_to("source_styles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/source_styles/1/edit").to route_to("source_styles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/source_styles").to route_to("source_styles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/source_styles/1").to route_to("source_styles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/source_styles/1").to route_to("source_styles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/source_styles/1").to route_to("source_styles#destroy", id: "1")
    end
  end
end
