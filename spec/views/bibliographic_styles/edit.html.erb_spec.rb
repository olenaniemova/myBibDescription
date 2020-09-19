require 'rails_helper'

RSpec.describe "bibliographic_styles/edit", type: :view do
  before(:each) do
    @bibliographic_style = assign(:bibliographic_style, BibliographicStyle.create!(
      title: "MyString",
      description: "MyString"
    ))
  end

  it "renders the edit bibliographic_style form" do
    render

    assert_select "form[action=?][method=?]", bibliographic_style_path(@bibliographic_style), "post" do

      assert_select "input[name=?]", "bibliographic_style[title]"

      assert_select "input[name=?]", "bibliographic_style[description]"
    end
  end
end
