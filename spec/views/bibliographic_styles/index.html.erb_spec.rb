require 'rails_helper'

RSpec.describe "bibliographic_styles/index", type: :view do
  before(:each) do
    assign(:bibliographic_styles, [
      BibliographicStyle.create!(
        title: "Title",
        description: "Description"
      ),
      BibliographicStyle.create!(
        title: "Title",
        description: "Description"
      )
    ])
  end

  it "renders a list of bibliographic_styles" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
  end
end
