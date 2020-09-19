require 'rails_helper'

RSpec.describe "bibliographic_description_items/show", type: :view do
  before(:each) do
    @bibliographic_description_item = assign(:bibliographic_description_item, BibliographicDescriptionItem.create!(
      title: "Title",
      year: 2,
      publisher: "Publisher",
      source_style: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Publisher/)
    expect(rendered).to match(//)
  end
end
