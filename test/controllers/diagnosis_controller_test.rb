require "test_helper"

class DiagnosisControllerTest < ActionDispatch::IntegrationTest
  test "should get result" do
    get diagnosis_result_url
    assert_response :success
  end
end
