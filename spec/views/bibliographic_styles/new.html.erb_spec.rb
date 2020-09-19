require 'rails_helper'

RSpec.describe "bibliographic_styles/new", type: :view do
  before(:each) do
    assign(:bibliographic_style, BibliographicStyle.new(
      title: "MyString",
      description: "MyString"
    ))
  end

  it "renders new bibliographic_style form" do
    render

    assert_select "form[action=?][method=?]", bibliographic_styles_path, "post" do

      assert_select "input[name=?]", "bibliographic_style[title]"

      assert_select "input[name=?]", "bibliographic_style[description]"
    end
  end
end
