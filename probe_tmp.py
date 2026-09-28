"""Throwaway probe 2: full semantics trees of login and dashboard pages."""
import time

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait

URL = "http://localhost:3000"

TREE_JS = """
function describe(el, depth) {
  const attrs = [];
  for (const a of el.attributes) {
    if (a.name === 'style') continue;
    if (a.name === 'id') continue;
    attrs.push(a.name + '=' + a.value);
  }
  let out = '  '.repeat(depth) + '<' + el.tagName.toLowerCase() + '>';
  if (attrs.length) out += ' [' + attrs.join(' ') + ']';
  out += '\\n';
  for (const child of el.children) out += describe(child, depth + 1);
  return out;
}
const host = document.querySelector('flt-semantics-host');
return describe(host, 0);
"""


def ident(d, name):
    return d.find_element(
        By.CSS_SELECTOR, f'[flt-semantics-identifier="{name}"]')


def type_text(d, name, text):
    el = ident(d, name)
    el.click()
    WebDriverWait(d, 10).until(
        lambda dd: dd.switch_to.active_element
        if dd.execute_script(
            "return document.activeElement && document.activeElement.tagName === 'INPUT';")
        else False)
    d.switch_to.active_element.send_keys(Keys.CONTROL, "a")
    d.switch_to.active_element.send_keys(text)


def main():
    options = Options()
    options.add_argument("--window-size=1400,900")
    driver = webdriver.Chrome(options=options)
    try:
        driver.get(URL)
        WebDriverWait(driver, 120).until(lambda d: len(d.find_elements(
            By.CSS_SELECTOR, '[flt-semantics-identifier="login_button"]')) > 0)
        print("=========== LOGIN TREE ===========")
        print(driver.execute_script(TREE_JS))

        type_text(driver, "login_username", "ahmed")
        type_text(driver, "login_password", "123456")
        ident(driver, "login_button").click()
        WebDriverWait(driver, 30).until(lambda d: len(d.find_elements(
            By.CSS_SELECTOR, '[flt-semantics-identifier="dashboard"]')) > 0)
        time.sleep(1)
        print("=========== DASHBOARD TREE ===========")
        print(driver.execute_script(TREE_JS))
    finally:
        driver.quit()


if __name__ == "__main__":
    main()
