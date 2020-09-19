require 'rails_helper'

RSpec.describe "sources/new", type: :view do
  before(:each) do
    assign(:source, Source.new(
      title: "MyString",
      description: "MyString"
    ))
  end

  it "renders new source form" do
    render

    assert_select "form[action=?][method=?]", sources_path, "post" do

      assert_select "input[name=?]", "source[title]"

      assert_select "input[name=?]", "source[description]"
    end
  end
end
