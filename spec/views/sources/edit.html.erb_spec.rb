require 'rails_helper'

RSpec.describe "sources/edit", type: :view do
  before(:each) do
    @source = assign(:source, Source.create!(
      title: "MyString",
      description: "MyString"
    ))
  end

  it "renders the edit source form" do
    render

    assert_select "form[action=?][method=?]", source_path(@source), "post" do

      assert_select "input[name=?]", "source[title]"

      assert_select "input[name=?]", "source[description]"
    end
  end
end
