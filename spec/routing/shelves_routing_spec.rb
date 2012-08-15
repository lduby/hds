require "spec_helper"

describe ShelvesController do
  describe "routing" do

    it "routes to #index" do
      get("/shelves").should route_to("shelves#index")
    end

    it "routes to #new" do
      get("/shelves/new").should route_to("shelves#new")
    end

    it "routes to #show" do
      get("/shelves/1").should route_to("shelves#show", :id => "1")
    end

    it "routes to #edit" do
      get("/shelves/1/edit").should route_to("shelves#edit", :id => "1")
    end

    it "routes to #create" do
      post("/shelves").should route_to("shelves#create")
    end

    it "routes to #update" do
      put("/shelves/1").should route_to("shelves#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/shelves/1").should route_to("shelves#destroy", :id => "1")
    end

  end
end
