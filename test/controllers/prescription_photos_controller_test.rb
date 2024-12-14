require 'test_helper'

class PrescriptionPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prescription_photo = prescription_photos(:one)
  end

  test "should get index" do
    get prescription_photos_url, as: :json
    assert_response :success
  end

  test "should create prescription_photo" do
    assert_difference('PrescriptionPhoto.count') do
      post prescription_photos_url, params: { prescription_photo: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show prescription_photo" do
    get prescription_photo_url(@prescription_photo), as: :json
    assert_response :success
  end

  test "should update prescription_photo" do
    patch prescription_photo_url(@prescription_photo), params: { prescription_photo: {  } }, as: :json
    assert_response 200
  end

  test "should destroy prescription_photo" do
    assert_difference('PrescriptionPhoto.count', -1) do
      delete prescription_photo_url(@prescription_photo), as: :json
    end

    assert_response 204
  end
end
