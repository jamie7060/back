require 'test_helper'

class HealthNewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @health_news = health_news(:one)
  end

  test "should get index" do
    get health_news_index_url, as: :json
    assert_response :success
  end

  test "should create health_news" do
    assert_difference('HealthNews.count') do
      post health_news_index_url, params: { health_news: { press: @health_news.press, url: @health_news.url } }, as: :json
    end

    assert_response 201
  end

  test "should show health_news" do
    get health_news_url(@health_news), as: :json
    assert_response :success
  end

  test "should update health_news" do
    patch health_news_url(@health_news), params: { health_news: { press: @health_news.press, url: @health_news.url } }, as: :json
    assert_response 200
  end

  test "should destroy health_news" do
    assert_difference('HealthNews.count', -1) do
      delete health_news_url(@health_news), as: :json
    end

    assert_response 204
  end
end
