require 'test_helper'

class SupplementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplement = supplements(:one)
  end

  test "should get index" do
    get supplements_url, as: :json
    assert_response :success
  end

  test "should create supplement" do
    assert_difference('Supplement.count') do
      post supplements_url, params: { supplement: { name: @supplement.name, photo_url: @supplement.photo_url, price: @supplement.price, product_url: @supplement.product_url, rating: @supplement.rating, shopping_site: @supplement.shopping_site, shoppingmall_reviews: @supplement.shoppingmall_reviews } }, as: :json
    end

    assert_response 201
  end

  test "should show supplement" do
    get supplement_url(@supplement), as: :json
    assert_response :success
  end

  test "should update supplement" do
    patch supplement_url(@supplement), params: { supplement: { name: @supplement.name, photo_url: @supplement.photo_url, price: @supplement.price, product_url: @supplement.product_url, rating: @supplement.rating, shopping_site: @supplement.shopping_site, shoppingmall_reviews: @supplement.shoppingmall_reviews } }, as: :json
    assert_response 200
  end

  test "should destroy supplement" do
    assert_difference('Supplement.count', -1) do
      delete supplement_url(@supplement), as: :json
    end

    assert_response 204
  end
end
