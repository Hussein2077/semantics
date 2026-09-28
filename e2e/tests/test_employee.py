import pytest
from pages.login_page import LoginPage
from tests.test_login import DEMO_PASSWORD, DEMO_USERNAME


@pytest.fixture
def employee_page(driver, base_url):
    """Login with the demo credentials and open the employee screen."""
    login = LoginPage(driver, base_url).open()
    login.enter_username(DEMO_USERNAME)
    login.enter_password(DEMO_PASSWORD)
    login.click_login()
    dashboard = login.wait_for_dashboard()
    return dashboard.open_employees()


def test_employee_creation(employee_page):
    employee_page.add_new()
    employee_page.fill_form("EMP001", "Ahmed Ali", "IT", "ahmed@example.com")
    employee_page.save()

    employee_page.wait_row_visible("EMP001")

    assert employee_page.wait_success_message() == "Employee EMP001 saved"
    assert "EMP001" in employee_page.grid_text()
    assert "Ahmed Ali" in employee_page.grid_text()


def test_employee_validation(employee_page):
    employee_page.save()

    assert employee_page.wait_error_message() == "Form contains validation errors"
    assert employee_page.wait_field_error("employee_number") == "Employee Number is required"
    assert employee_page.wait_field_error("employee_name") == "Employee Name is required"
    assert employee_page.wait_field_error("employee_department") == "Department is required"
    assert employee_page.wait_field_error("employee_email") == "Email is required"


def test_employee_search(employee_page):
    employee_page.add_new()
    employee_page.fill_form("EMP002", "Priya Sharma", "HR", "priya@example.com")
    employee_page.save()
    employee_page.wait_row_visible("EMP002")

    # Search by employee number
    employee_page.search("EMP002")
    employee_page.wait_row_visible("EMP002")

    # Search by employee name
    employee_page.search("Priya")
    employee_page.wait_row_visible("EMP002")

    # No match -> row disappears
    employee_page.search("does-not-exist")
    employee_page.wait_row_gone("EMP002")


def test_employee_delete(employee_page):
    employee_page.add_new()
    employee_page.fill_form("EMP003", "Sara Hassan", "Finance", "sara@example.com")
    employee_page.save()
    employee_page.wait_row_visible("EMP003")

    employee_page.select_employee("EMP003")
    employee_page.delete()

    assert employee_page.wait_row_gone("EMP003")
    assert employee_page.wait_success_message() == "Employee EMP003 deleted"
