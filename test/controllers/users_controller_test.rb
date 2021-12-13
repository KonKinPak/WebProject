require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @approve_user = users(:approve_user)
    @ban_user = users(:ban_user)
    @profile_user = users(:profile_user)
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { username: "test", nickname: "test", password: "test",password_confirmation: "test"} }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do 
    get user_url(@approve_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@approve_user)
    assert_redirected_to feed_url
  end

  test "should update user" do
    patch user_url(@approve_user), params: { user: { id:1,nickname: @approve_user.nickname, username: "change",password:"approve",password_confirmation:"approve" } }
    assert_redirected_to user_url(@approve_user)  
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@approve_user)
    end
  end

  test "should login user" do
    post main_url,params:{username:"approve",password:"approve"}
    assert_redirected_to feed_url
  end

  test "should not login" do
    post main_url,params:{username:"ban",password:"ban"}
    assert_redirected_to main_url
    post main_url,params:{username:"not_approve",password:"not_approve"}
    assert_redirected_to main_url
  end

  test "should get index" do
    post main_url,params:{username:"admin",password:"admin"}
    get users_url
    assert_response :success
  end

  test "should get feed" do
    get main_url
    get feed_url
    assert_response :success
    post main_url,params:{username:"approve",password:"approve"}
    get feed_url
    assert_response :success
  end

  test "should profile user" do
    get profile_user_url("approve")
    assert_response :success
    post main_url,params:{username:"approve",password:"approve"}
    get profile_user_url("approve")
    assert_response :success
  end

  test "should follow user" do
    post main_url,params:{username:"user",password:"user"}
    assert_difference('Follow.count') do
      get profile_user_url("approve")
      post "/profile/approve/follow",params:{nickname:"approve"}
    end
  end

  test "should unfollow user" do
    post main_url,params:{username:"approve",password:"approve"}
    assert_difference('Follow.count', -1) do
      get profile_user_url("user")
      post "/profile/user/unfollow",params:{nickname:"user"}
    end
  end

end
