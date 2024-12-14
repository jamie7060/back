require 'test_helper'

class AdverseEffectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adverse_effect = adverse_effects(:one)
  end

  test "should get index" do
    get adverse_effects_url, as: :json
    assert_response :success
  end

  test "should create adverse_effect" do
    assert_difference('AdverseEffect.count') do
      post adverse_effects_url, params: { adverse_effect: { symptom_code: @adverse_effect.symptom_code, symptom_name: @adverse_effect.symptom_name } }, as: :json
    end

    assert_response 201
  end

  test "should show adverse_effect" do
    get adverse_effect_url(@adverse_effect), as: :json
    assert_response :success
  end

  test "should update adverse_effect" do
    patch adverse_effect_url(@adverse_effect), params: { adverse_effect: { symptom_code: @adverse_effect.symptom_code, symptom_name: @adverse_effect.symptom_name } }, as: :json
    assert_response 200
  end

  test "should destroy adverse_effect" do
    assert_difference('AdverseEffect.count', -1) do
      delete adverse_effect_url(@adverse_effect), as: :json
    end

    assert_response 204
  end
end
