"""Chrome WebDriver factory.

Selenium 4.49.0 ships Selenium Manager, which downloads the matching
ChromeDriver automatically - no manual chromedriver setup is required as long
as Google Chrome is installed.
"""

from selenium import webdriver

WINDOW_WIDTH = 1400
WINDOW_HEIGHT = 900


def create_driver() -> webdriver.Chrome:
    """Create a Chrome WebDriver with a fixed window size."""
    options = webdriver.ChromeOptions()
    options.add_argument(f"--window-size={WINDOW_WIDTH},{WINDOW_HEIGHT}")
    options.add_argument("--disable-search-engine-choice-screen")

    driver = webdriver.Chrome(options=options)
    driver.set_window_size(WINDOW_WIDTH, WINDOW_HEIGHT)
    driver.set_page_load_timeout(60)
    return driver
