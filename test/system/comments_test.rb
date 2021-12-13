require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @comment = comments(:one)
    @approve_user = users(:approve_user)
    @ban_user = users(:ban_user)
    @profile_user = users(:profile_user)
    @not_approve_user = users(:not_approve_user)
  end

  test "Comment" do
    visit main_url
    fill_in "Username", with: @profile_user.nickname
    fill_in "Password", with: "user"
    click_on "Log in"
    click_link "Title Post"
    fill_in "Say something...", with: "Hello comment"
    click_on "Submit"
    assert_text "Comment was successfully created."
    within("#comment-user") do
      assert_link @profile_user.nickname
      click_button "Like", match: :first
      assert_button "Unlike"
      click_button "Unlike", match: :first
      assert_button "Like"
    end    
  end

end
