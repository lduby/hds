require 'spec_helper'

describe "children/index" do
  before(:each) do
    assign(:children, [
      stub_model(Child,
        :first_name => "First Name"
      ),
      stub_model(Child,
        :first_name => "First Name"
      )
    ])
  end

  it "renders a list of children" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
  end
end
