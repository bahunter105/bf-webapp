require "application_system_test_case"

class EnrollInWorkshopsTest < ApplicationSystemTestCase
  setup do
    @workshop = workshops(:one)
  end

  test "visiting the workshop index" do
    visit workshops_url

    save_and_open_screenshot
    assert_selector "h5", text: "MyString"
  end

  test "searching workshops" do
    visit workshops_url
    fill_in 'Find a workshop', with: 'Test'

    click_on 'button'
    save_and_open_screenshot
    assert_selector "h5", text: "Test"
  end

  test "visiting workshop show page" do
    visit workshop_url(@workshop)
    save_and_open_screenshot
    assert_selector "h2", text: "MyString"
  end
end
