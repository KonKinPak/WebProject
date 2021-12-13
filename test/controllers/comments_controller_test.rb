require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    @post = posts(:one)
  end

  test "should get index" do
    post main_url,params:{username:"admin",password:"admin"}
    get comments_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    post main_url,params:{username:"approve",password:"approve"}
    get post_url(@comment.post)
    assert_difference('Comment.count') do
      post comments_url, params: { comment: { msg: "eiei", post_id: 1, user_id: 1 } }
    end

    assert_redirected_to "/posts/#{Comment.last.post_id}"
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_redirected_to post_url(@comment.post)
  end

  test "should destroy comment" do
    post main_url,params:{username:"admin",password:"admin"}
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end

  test "should like" do
    post main_url,params:{username:"user",password:"user"}
    get post_url(@post)
    assert_difference("@comment.likes.count") do
      get post_url(@post)
      post "/comment/1/like",params:{comment_id:1}
    end
  end

  test "should unlike" do
    post main_url,params:{username:"approve",password:"approve"}
    get post_url(@post)
    assert_difference("@comment.likes.count",-1) do
      get post_url(@post)
      post "/comment/1/unlike",params:{comment_id:1}
    end
  end
end
