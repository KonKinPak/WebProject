require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @approve_user = users(:approve_user)
    @ban_user = users(:ban_user)
    @profile_user = users(:profile_user)
    @not_approve_user = users(:not_approve_user)
    @post = posts(:one)
  end

  test "New Post" do
    visit main_path
    fill_in "Username", with: @approve_user.username
    fill_in "Password", with: 'approve'
    click_on "Log in"
    sleep(10)
    click_on "Write"
    sleep(10)
    fill_in "Title", with: "Title567"
    #fill_in "Title", with: "Title567"
    find("trix-editor").set("Body5Body567asdgBody567asdgBody567asdgBody567asdg67asdgBody567asdgBody567asdgBody567asdgBody567asdgBody567asdgBody567asdg")
    #fill_in "Body", with: "Body5Body567asdgBody567asdgBody567asdgBody567asdg67asdgBody567asdgBody567asdgBody567asdgBody567asdgBody567asdgBody567asdg"
    click_on "Submit"
    assert_text "Post was successfully created."
  end
end
