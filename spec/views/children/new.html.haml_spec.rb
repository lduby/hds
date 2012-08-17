require 'spec_helper'

describe "children/new" do
  before(:each) do
    assign(:child, stub_model(Child,
      :first_name => "MyString"
    ).as_new_record)
  end

  it "renders new child form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => children_path, :method => "post" do
      assert_select "input#child_first_name", :name => "child[first_name]"
    end
  end
end
