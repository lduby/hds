require 'spec_helper'

describe "shelves/edit" do
  before(:each) do
    @shelf = assign(:shelf, stub_model(Shelf,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit shelf form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shelves_path(@shelf), :method => "post" do
      assert_select "input#shelf_name", :name => "shelf[name]"
      assert_select "textarea#shelf_description", :name => "shelf[description]"
    end
  end
end
