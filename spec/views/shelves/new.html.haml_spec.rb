require 'spec_helper'

describe "shelves/new" do
  before(:each) do
    assign(:shelf, stub_model(Shelf,
      :name => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new shelf form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shelves_path, :method => "post" do
      assert_select "input#shelf_name", :name => "shelf[name]"
      assert_select "textarea#shelf_description", :name => "shelf[description]"
    end
  end
end
