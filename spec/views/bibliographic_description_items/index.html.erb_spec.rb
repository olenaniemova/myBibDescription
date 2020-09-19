require 'rails_helper'

RSpec.describe "bibliographic_description_items/index", type: :view do
  before(:each) do
    assign(:bibliographic_description_items, [
      BibliographicDescriptionItem.create!(
        title: "Title",
        year: 2,
        publisher: "Publisher",
        source_style: nil
      ),
      BibliographicDescriptionItem.create!(
        title: "Title",
        year: 2,
        publisher: "Publisher",
        source_style: nil
      )
    ])
  end

  it "renders a list of bibliographic_description_items" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Publisher".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
