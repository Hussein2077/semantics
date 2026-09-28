from pages.base_page import BasePage


class EmployeePage(BasePage):
    """Page object for the employee CRUD screen."""

    def wait_loaded(self) -> None:
        self.wait_visible("employee_grid")

    # ------------------------------------------------------------- actions
    def add_new(self) -> None:
        self.click("employee_add_button")

    def save(self) -> None:
        self.click("employee_save_button")

    def cancel(self) -> None:
        self.click("employee_cancel_button")

    def delete(self) -> None:
        self.click("employee_delete_button")

    def fill_form(self, number: str, name: str, department: str,
                  email: str) -> None:
        self.type_text("employee_number", number)
        self.type_text("employee_name", name)
        self.type_text("employee_department", department)
        self.type_text("employee_email", email)

    def search(self, query: str) -> None:
        self.type_text("employee_search", query)

    def select_employee(self, number: str) -> None:
        self.click(f"employee_row_{number}")

    # ------------------------------------------------------------- waits
    def wait_row_visible(self, number: str):
        return self.wait_visible(f"employee_row_{number}")

    def wait_row_gone(self, number: str) -> bool:
        return self.wait_hidden(f"employee_row_{number}")

    def wait_success_message(self) -> str:
        return self.text_of("success_message")

    def wait_error_message(self) -> str:
        return self.text_of("error_message")

    def wait_field_error(self, field: str) -> str:
        return self.text_of(f"{field}_error")

    def grid_text(self) -> str:
        return self.text_of("employee_grid")
