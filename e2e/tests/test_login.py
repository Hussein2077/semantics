from pages.login_page import LoginPage

DEMO_USERNAME = "ahmed"
DEMO_PASSWORD = "123456"


def test_login_success(driver, base_url):
    login = LoginPage(driver, base_url).open()
    login.enter_username(DEMO_USERNAME)
    login.enter_password(DEMO_PASSWORD)
    login.click_login()

    dashboard = login.wait_for_dashboard()

    assert dashboard.is_loaded()
    assert dashboard.username_text() == "Welcome ahmed"


def test_login_invalid_credentials_shows_error(driver, base_url):
    login = LoginPage(driver, base_url).open()
    login.enter_username(DEMO_USERNAME)
    login.enter_password("wrong_password")
    login.click_login()

    assert login.wait_for_login_error() == "Invalid username or password"
