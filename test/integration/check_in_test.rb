require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  test "the button should not be visible if there is no previous patient information" do
    Capybara.current_driver = :selenium
    sign_in_as "Check in"
    refute find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be hidden"
  end

  test "should display the button if previous patient information is available" do
    Capybara.current_driver = :selenium
    patient = Factory(:patient)
    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be visible"
  end

  test "populates each field when clicked" do
    Capybara.current_driver = :selenium
    phone = "230-111-1111"; street = "12 St."; zip = "90210"
    city = "Beverley Hills"; state = "CA"

    patient = Factory(:patient, :phone => phone, :street => street, :zip => zip,
                      :city => city, :state => state)

    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    click_button 'Same as previous patient'

    assert_equal find_field('Phone').value, phone
    assert_equal find_field('Street').value, street
    assert_equal find_field('Zip').value, zip
    assert_equal find_field('City').value, city
    assert_equal find_field('State').value, state
  end
end