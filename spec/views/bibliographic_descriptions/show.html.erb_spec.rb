require 'rails_helper'

RSpec.describe "bibliographic_descriptions/show", type: :view do
  before(:each) do
    @bibliographic_description = assign(:bibliographic_description, BibliographicDescription.create!(
      title: "Title",
      description: "Description",
      profile: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
  end
end
