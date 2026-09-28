"""Pytest fixtures and failure-screenshot hook for the Selenium E2E suite.

The Flutter application must already be running on BASE_URL (default
http://localhost:3000) before these tests execute - see README.md.
"""

import datetime
import os

import pytest

from utils.driver import create_driver

BASE_URL = os.environ.get("E2E_BASE_URL", "http://localhost:3000")
SCREENSHOT_DIR = os.path.join(os.path.dirname(__file__), "screenshots")


@pytest.hookimpl(hookwrapper=True, tryfirst=True)
def pytest_runtest_makereport(item, call):
    """Attach phase reports to the test item so the driver fixture can see
    whether the test failed and capture a screenshot on teardown."""
    outcome = yield
    report = outcome.get_result()
    setattr(item, "rep_" + report.when, report)


@pytest.fixture
def base_url():
    return BASE_URL


@pytest.fixture
def driver(request):
    """Function-scoped Chrome session: one fresh browser per test, which also
    guarantees a clean in-memory Flutter state per test."""
    web_driver = create_driver()
    yield web_driver

    report = getattr(request.node, "rep_call", None)
    setup_report = getattr(request.node, "rep_setup", None)
    failed = (report is not None and report.failed) or (
        setup_report is not None and setup_report.failed
    )
    if failed:
        _save_screenshot(web_driver, request.node.name)
    web_driver.quit()


def _save_screenshot(web_driver, test_name: str) -> None:
    try:
        os.makedirs(SCREENSHOT_DIR, exist_ok=True)
        stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join(SCREENSHOT_DIR, f"{test_name}_{stamp}.png")
        web_driver.save_screenshot(path)
        print(f"\nScreenshot saved: {path}")
    except Exception as exc:  # never mask the real test failure
        print(f"\nCould not save screenshot: {exc}")
