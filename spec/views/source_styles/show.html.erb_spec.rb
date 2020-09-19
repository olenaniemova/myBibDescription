require 'rails_helper'

RSpec.describe "source_styles/show", type: :view do
  before(:each) do
    @source_style = assign(:source_style, SourceStyle.create!(
      title: "Title",
      description: "Description",
      schema: "Schema",
      source: nil,
      bibliographic_style: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Schema/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
