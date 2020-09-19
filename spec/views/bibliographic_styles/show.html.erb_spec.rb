require 'rails_helper'

RSpec.describe "bibliographic_styles/show", type: :view do
  before(:each) do
    @bibliographic_style = assign(:bibliographic_style, BibliographicStyle.create!(
      title: "Title",
      description: "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
  end
end
