require "test_helper"

class DiagnosisControllerTest < ActionDispatch::IntegrationTest
  test "should get result" do
    diagnosis = diagnoses(:one)
    get diagnosis_path(diagnosis.token)
    assert_response :success
  end
end
