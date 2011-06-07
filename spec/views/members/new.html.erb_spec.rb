require 'spec_helper'

describe "members/new.html.erb" do
  before(:each) do
    assign(:member, stub_model(Member,
      :first_name => "MyString",
      :last_name => "MyString",
      :club_id => 1,
      :sex => "MyString",
      :email => "MyString",
      :city => "MyString",
      :address => "MyString",
      :postale_code => 1,
      :chip_id => 1,
      :password => "MyString"
    ).as_new_record)
  end

  it "renders new member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => members_path, :method => "post" do
      assert_select "input#member_first_name", :name => "member[first_name]"
      assert_select "input#member_last_name", :name => "member[last_name]"
      assert_select "input#member_club_id", :name => "member[club_id]"
      assert_select "input#member_sex", :name => "member[sex]"
      assert_select "input#member_email", :name => "member[email]"
      assert_select "input#member_city", :name => "member[city]"
      assert_select "input#member_address", :name => "member[address]"
      assert_select "input#member_postale_code", :name => "member[postale_code]"
      assert_select "input#member_chip_id", :name => "member[chip_id]"
      assert_select "input#member_password", :name => "member[password]"
    end
  end
end
