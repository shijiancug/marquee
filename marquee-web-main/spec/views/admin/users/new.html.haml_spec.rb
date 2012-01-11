require 'spec_helper'

describe "admin/users/new.html.haml" do
  before(:each) do
    assign(:admin_user, stub_model(Admin::User).as_new_record)
  end

  it "renders new admin_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_users_path, :method => "post" do
    end
  end
end
