require 'spec_helper'

describe "shelves/show" do
  before(:each) do
    @shelf = assign(:shelf, stub_model(Shelf,
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
  end
end
