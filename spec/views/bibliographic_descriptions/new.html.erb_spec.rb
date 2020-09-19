require 'rails_helper'

RSpec.describe "bibliographic_descriptions/new", type: :view do
  before(:each) do
    assign(:bibliographic_description, BibliographicDescription.new(
      title: "MyString",
      description: "MyString",
      profile: nil
    ))
  end

  it "renders new bibliographic_description form" do
    render

    assert_select "form[action=?][method=?]", bibliographic_descriptions_path, "post" do

      assert_select "input[name=?]", "bibliographic_description[title]"

      assert_select "input[name=?]", "bibliographic_description[description]"

      assert_select "input[name=?]", "bibliographic_description[profile_id]"
    end
  end
end
