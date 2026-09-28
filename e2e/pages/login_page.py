from pages.base_page import BasePage


class LoginPage(BasePage):
    """Page object for the login screen."""

    def open(self) -> "LoginPage":
        self.driver.get(self.base_url)
        self.wait_loaded()
        return self

    def wait_loaded(self) -> None:
        self.wait_visible("login_button")

    # ------------------------------------------------------------- actions
    def enter_username(self, username: str) -> None:
        self.type_text("login_username", username)

    def enter_password(self, password: str) -> None:
        self.type_text("login_password", password)

    def click_login(self) -> None:
        self.click("login_button")

    # ------------------------------------------------------------- waits
    def wait_for_dashboard(self):
        # Imported lazily: dashboard_page imports this module for logout().
        from pages.dashboard_page import DashboardPage

        self.wait_visible("dashboard")
        return DashboardPage(self.driver, self.base_url)

    def wait_for_login_error(self) -> str:
        return self.text_of("login_error")

    def wait_for_username_error(self) -> str:
        return self.text_of("login_username_error")

    def wait_for_password_error(self) -> str:
        return self.text_of("login_password_error")
