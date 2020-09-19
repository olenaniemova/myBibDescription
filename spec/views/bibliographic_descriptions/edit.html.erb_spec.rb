require 'rails_helper'

RSpec.describe "bibliographic_descriptions/edit", type: :view do
  before(:each) do
    @bibliographic_description = assign(:bibliographic_description, BibliographicDescription.create!(
      title: "MyString",
      description: "MyString",
      profile: nil
    ))
  end

  it "renders the edit bibliographic_description form" do
    render

    assert_select "form[action=?][method=?]", bibliographic_description_path(@bibliographic_description), "post" do

      assert_select "input[name=?]", "bibliographic_description[title]"

      assert_select "input[name=?]", "bibliographic_description[description]"

      assert_select "input[name=?]", "bibliographic_description[profile_id]"
    end
  end
end
