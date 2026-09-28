from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class LoginPage:

    URL = "http://localhost:3000"

    USERNAME = (By.CSS_SELECTOR, '[aria-label="login_username"]')
    PASSWORD = (By.CSS_SELECTOR, '[aria-label="login_password"]')
    LOGIN_BUTTON = (By.CSS_SELECTOR, '[aria-label="login_button"]')
    DASHBOARD = (By.CSS_SELECTOR, '[aria-label="dashboard"]')

    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 20)

    def open(self):
        self.driver.get(self.URL)

    def enter_username(self, username):
        element = self.wait.until(
            EC.element_to_be_clickable(self.USERNAME)
        )

        element.click()
        element.send_keys(username)

    def enter_password(self, password):
        element = self.wait.until(
            EC.element_to_be_clickable(self.PASSWORD)
        )

        element.click()
        element.send_keys(password)

    def click_login(self):
        self.wait.until(
            EC.element_to_be_clickable(self.LOGIN_BUTTON)
        ).click()

    def wait_for_dashboard(self):
        return self.wait.until(
            EC.visibility_of_element_located(self.DASHBOARD)
        )