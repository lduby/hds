require "spec_helper"

describe ChildrenController do
  describe "routing" do

    it "routes to #index" do
      get("/children").should route_to("children#index")
    end

    it "routes to #new" do
      get("/children/new").should route_to("children#new")
    end

    it "routes to #show" do
      get("/children/1").should route_to("children#show", :id => "1")
    end

    it "routes to #edit" do
      get("/children/1/edit").should route_to("children#edit", :id => "1")
    end

    it "routes to #create" do
      post("/children").should route_to("children#create")
    end

    it "routes to #update" do
      put("/children/1").should route_to("children#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/children/1").should route_to("children#destroy", :id => "1")
    end

  end
end
