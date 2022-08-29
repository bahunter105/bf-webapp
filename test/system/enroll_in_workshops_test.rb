require "application_system_test_case"

class EnrollInWorkshopsTest < ApplicationSystemTestCase
  test "visiting the workshop index" do
    visit workshops_url

    save_and_open_screenshot
    assert_selector "h5", text: "MyString"
  end
end
