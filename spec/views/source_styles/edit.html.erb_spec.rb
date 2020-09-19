require 'rails_helper'

RSpec.describe "source_styles/edit", type: :view do
  before(:each) do
    @source_style = assign(:source_style, SourceStyle.create!(
      title: "MyString",
      description: "MyString",
      schema: "MyString",
      source: nil,
      bibliographic_style: nil
    ))
  end

  it "renders the edit source_style form" do
    render

    assert_select "form[action=?][method=?]", source_style_path(@source_style), "post" do

      assert_select "input[name=?]", "source_style[title]"

      assert_select "input[name=?]", "source_style[description]"

      assert_select "input[name=?]", "source_style[schema]"

      assert_select "input[name=?]", "source_style[source_id]"

      assert_select "input[name=?]", "source_style[bibliographic_style_id]"
    end
  end
end
