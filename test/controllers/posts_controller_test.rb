require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    post main_url,params:{username:"approve",password:"approve"}
    assert_difference('Post.count') do
      post posts_url, params: { post: { body:"eieieieiei", title: "hahaha", user_id: 1 } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    post main_url,params:{username:"approve",password:"approve"}
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    post main_url,params:{username:"approve",password:"approve"}
    patch post_url(@post), params: { post: { body: "haha", title: "hahaha", user_id: 1 } }
    assert_redirected_to post_url(@post)
  end

  test "should like" do
    post main_url,params:{username:"user",password:"user"}
    get post_url(@post)
    assert_difference("@post.likes.count") do
      get post_url(@post)
      post "/post/1/like",params:{post_id:1}
    end
  end
  test "should unlike" do
    post main_url,params:{username:"approve",password:"approve"}
    get post_url(@post)
    assert_difference("@post.likes.count",-1) do
      get post_url(@post)
      post "/post/1/unlike",params:{post_id:1}
    end
  end
end
