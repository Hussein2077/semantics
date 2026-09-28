from tests.test_login import DEMO_PASSWORD, DEMO_USERNAME
from pages.login_page import LoginPage


def test_username_required(driver, base_url):
    login = LoginPage(driver, base_url).open()
    login.click_login()

    assert login.wait_for_username_error() == "Username is required"


def test_password_required(driver, base_url):
    login = LoginPage(driver, base_url).open()
    login.enter_username(DEMO_USERNAME)
    login.click_login()

    assert login.wait_for_password_error() == "Password is required"


def test_password_too_short(driver, base_url):
    login = LoginPage(driver, base_url).open()
    login.enter_username(DEMO_USERNAME)
    login.enter_password("123")
    login.click_login()

    error = login.wait_for_password_error()

    assert error == "Password must be at least 6 characters"
    assert DEMO_PASSWORD == "123456"  # guard: demo creds stay in sync
