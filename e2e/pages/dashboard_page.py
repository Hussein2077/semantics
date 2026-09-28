from pages.base_page import BasePage


class DashboardPage(BasePage):
    """Page object for the dashboard screen."""

    def is_loaded(self) -> bool:
        self.wait_visible("dashboard")
        return True

    def username_text(self) -> str:
        return self.text_of("dashboard_username")

    # ------------------------------------------------------------- actions
    def open_employees(self):
        # Imported lazily: employee_page's test fixture imports login_page,
        # which imports this module for wait_for_dashboard().
        from pages.employee_page import EmployeePage

        self.click("employee_open_button")
        page = EmployeePage(self.driver, self.base_url)
        page.wait_loaded()
        return page

    def logout(self):
        from pages.login_page import LoginPage

        self.click("logout_button")
        page = LoginPage(self.driver, self.base_url)
        page.wait_loaded()
        return page
