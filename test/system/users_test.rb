require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @approve_user = users(:approve_user)
    @ban_user = users(:ban_user)
    @profile_user = users(:profile_user)
    @not_approve_user = users(:not_approve_user)
  end

  test "login_fail" do
    #wrong user
    visit main_path
    fill_in "Username", with: @approve_user.username
    fill_in "Password", with: 'EiEi'
    click_on "Log in"
    assert_text "Username/password not valid"
    #ban user
    visit main_path
    fill_in "Username", with: @ban_user.username
    fill_in "Password", with: 'ban'
    click_on "Log in"
    assert_text "This account was banned. Plase contact admin"
    #not approve user
    visit main_path
    fill_in "Username", with: @not_approve_user.username
    fill_in "Password", with: 'not_approve'
    click_on "Log in"
    assert_text "Please wait approval"
  end

  test "search user,(un)follow user" do
    visit main_url
    fill_in "Username", with: @approve_user.username
    fill_in "Password", with: "approve"
    click_on "Log in"
    fill_in "Search for user", with: @profile_user.nickname
    click_on "Search"
    assert_text @profile_user.nickname
    click_button "Unfollow"
    assert_text "You just unfollow " + @profile_user.nickname
    click_button "Follow"
    assert_text "You just follow " + @profile_user.nickname
  end

  test "Show post,(un)like post,comment" do
    visit main_url
    fill_in "Username", with: @profile_user.username
    fill_in "Password", with: "user"
    click_on "Log in"
    click_link "Title Post"
    click_button "Like", match: :first
    assert_button "Unlike"
    click_button "Unlike", match: :first
    assert_button "Like"
  end

  test "chat" do
    visit main_url
    fill_in "Username", with: @profile_user.username
    fill_in "Password", with: "user"
    click_on "Log in"
    click_on "Chat"
    assert_text "Chat"
    click_on "Group"
    fill_in "New group chat..", with: "Room"
    click_button "New Group"
    visit "/rooms"
    click_on "Group"
    assert_link "Room"
    click_link "Room"
    fill_in "Say something...", with: "Hello World !"
    click_on "Send"
    within("#messages") do
      assert_text "Hello World !"
    end
  end 

  test "not login" do
    visit feed_path
    click_on "Title Post"
    assert_text "Title Post"
  end   
end
