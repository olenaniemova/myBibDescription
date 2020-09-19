require 'rails_helper'

RSpec.describe "source_styles/index", type: :view do
  before(:each) do
    assign(:source_styles, [
      SourceStyle.create!(
        title: "Title",
        description: "Description",
        schema: "Schema",
        source: nil,
        bibliographic_style: nil
      ),
      SourceStyle.create!(
        title: "Title",
        description: "Description",
        schema: "Schema",
        source: nil,
        bibliographic_style: nil
      )
    ])
  end

  it "renders a list of source_styles" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: "Schema".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
