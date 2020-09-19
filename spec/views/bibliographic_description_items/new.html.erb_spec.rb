require 'rails_helper'

RSpec.describe "bibliographic_description_items/new", type: :view do
  before(:each) do
    assign(:bibliographic_description_item, BibliographicDescriptionItem.new(
      title: "MyString",
      year: 1,
      publisher: "MyString",
      source_style: nil
    ))
  end

  it "renders new bibliographic_description_item form" do
    render

    assert_select "form[action=?][method=?]", bibliographic_description_items_path, "post" do

      assert_select "input[name=?]", "bibliographic_description_item[title]"

      assert_select "input[name=?]", "bibliographic_description_item[year]"

      assert_select "input[name=?]", "bibliographic_description_item[publisher]"

      assert_select "input[name=?]", "bibliographic_description_item[source_style_id]"
    end
  end
end
