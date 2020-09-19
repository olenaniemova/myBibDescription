require 'rails_helper'

RSpec.describe "bibliographic_descriptions/index", type: :view do
  before(:each) do
    assign(:bibliographic_descriptions, [
      BibliographicDescription.create!(
        title: "Title",
        description: "Description",
        profile: nil
      ),
      BibliographicDescription.create!(
        title: "Title",
        description: "Description",
        profile: nil
      )
    ])
  end

  it "renders a list of bibliographic_descriptions" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
