require 'spec_helper'

describe "reviews/new" do
  before(:each) do
    assign(:review, stub_model(Review,
      :rating => 1,
      :details => "MyText"
    ).as_new_record)
  end

  it "renders new review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path, :method => "post" do
      assert_select "input#review_rating", :name => "review[rating]"
      assert_select "textarea#review_details", :name => "review[details]"
    end
  end
end
