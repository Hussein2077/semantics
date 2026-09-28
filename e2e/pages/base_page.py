"""Shared helpers for all Flutter Web page objects.

Locator strategy
----------------
Flutter Web (CanvasKit renderer, Flutter 3.41) exposes
`Semantics(identifier: ...)` as a `flt-semantics-identifier` attribute on the
`<flt-semantics>` element inside `flt-semantics-host` (light DOM, no shadow
root). Every locator in this project therefore targets:

    [flt-semantics-identifier="<identifier>"]

No XPath, no generated Flutter class names, no DOM hierarchy walks.
"""

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

DEFAULT_TIMEOUT_SECONDS = 30


class BasePage:
    def __init__(self, driver, base_url,
                 timeout: int = DEFAULT_TIMEOUT_SECONDS):
        self.driver = driver
        self.base_url = base_url
        self.wait = WebDriverWait(driver, timeout)

    # ------------------------------------------------------------- locators
    def locator(self, identifier: str):
        return (
            By.CSS_SELECTOR,
            f'[flt-semantics-identifier="{identifier}"]',
        )

    # ------------------------------------------------------------ raw waits
    def element(self, identifier: str):
        return self.wait.until(
            EC.presence_of_element_located(self.locator(identifier))
        )

    def wait_visible(self, identifier: str):
        return self.wait.until(
            EC.visibility_of_element_located(self.locator(identifier))
        )

    def wait_hidden(self, identifier: str) -> bool:
        """Wait until the semantics node is invisible or removed."""
        return self.wait.until(
            EC.invisibility_of_element_located(self.locator(identifier))
        )

    # ----------------------------------------------------------- actions
    def click(self, identifier: str) -> None:
        self.wait_visible(identifier).click()

    def text_of(self, identifier: str) -> str:
        return self.wait_visible(identifier).text

    def type_text(self, identifier: str, text: str) -> None:
        """Focus a Flutter text field through its semantics node and type.

        Clicking the <flt-semantics> element makes Flutter create a real
        <input> element (it becomes document.activeElement). Keys must be
        sent to that input so the value reaches the reactive_forms control.
        Select-all first so calling this twice replaces the previous value.
        """
        self.click(identifier)
        active_input = WebDriverWait(self.driver, 10).until(
            lambda d: d.switch_to.active_element
            if d.execute_script(
                "return document.activeElement && "
                "document.activeElement.tagName === 'INPUT';"
            )
            else False
        )
        active_input.send_keys(Keys.CONTROL, "a")
        active_input.send_keys(text)
