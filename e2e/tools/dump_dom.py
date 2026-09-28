"""Inspect how Flutter Web exposes Semantics identifiers in the real Chrome DOM.

Run while the Flutter app is serving on http://localhost:3000:

    .venv/Scripts/python e2e/tools/dump_dom.py

Prints the structure of flutter-view / flt-semantics-host and every element
carrying a `flt-semantics-identifier` attribute, so the Selenium locators in
e2e/pages/ can be written against the *actual* DOM representation.
"""

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait

URL = "http://localhost:3000"


def main() -> None:
    options = Options()
    options.add_argument("--window-size=1400,900")
    driver = webdriver.Chrome(options=options)
    try:
        driver.get(URL)

        # Wait until Flutter finished booting and rendered the semantics DOM.
        WebDriverWait(driver, 120).until(
            lambda d: d.execute_script(
                """
                const host = document.querySelector('flt-semantics-host');
                return !!host && host.querySelectorAll('flt-semantics').length > 0;
                """
            )
        )

        print("=== KEY CONTAINER ELEMENTS ===")
        for tag in (
            "flutter-view",
            "flt-glass-pane",
            "flt-semantics-host",
            "flt-text-editing-host",
        ):
            found = driver.execute_script(
                """
                const el = document.querySelector(arguments[0]);
                if (!el) return null;
                return {
                  tag: el.tagName.toLowerCase(),
                  parentChain: (() => {
                    const chain = [];
                    let n = el;
                    while (n && n !== document.body) {
                      chain.push(n.tagName.toLowerCase() +
                        (n.getRootNode() !== document ? ' (shadow)' : ''));
                      n = n.host || n.parentElement;
                    }
                    return chain.join(' < ');
                  })(),
                };
                """,
                tag,
            )
            print(f"{tag}: {found}")

        print("\n=== SEMANTICS ELEMENTS WITH IDENTIFIERS (login page) ===")
        nodes = driver.execute_script(
            """
            const out = [];
            document.querySelectorAll('[flt-semantics-identifier]').forEach(el => {
              const attrs = {};
              for (const a of el.attributes) attrs[a.name] = a.value;
              out.push({
                tag: el.tagName.toLowerCase(),
                role: el.getAttribute('role'),
                identifier: el.getAttribute('flt-semantics-identifier'),
                ariaLabel: el.getAttribute('aria-label'),
                ariaDisabled: el.getAttribute('aria-disabled'),
                text: (el.textContent || '').trim().slice(0, 80),
                attrs: attrs,
              });
            });
            return out;
            """
        )
        for n in nodes:
            print(f"\nidentifier={n['identifier']}")
            print(f"  tag={n['tag']} role={n['role']}")
            print(f"  aria-label={n['ariaLabel']!r} text={n['text']!r}")
            print(f"  all attributes: {n['attrs']}")

        print("\n=== FIRST LEVEL OF flt-semantics-host (structure sample) ===")
        tree = driver.execute_script(
            """
            function describe(el, depth, maxDepth) {
              if (depth > maxDepth) return '';
              const id = el.getAttribute ? el.getAttribute('flt-semantics-identifier') : null;
              const role = el.getAttribute ? el.getAttribute('role') : null;
              let line = '  '.repeat(depth) + '<' + el.tagName.toLowerCase() + '>';
              if (role) line += ' role=' + role;
              if (id) line += ' identifier=' + id;
              let out = line + '\\n';
              for (const child of el.children) out += describe(child, depth + 1, maxDepth);
              return out;
            }
            const host = document.querySelector('flt-semantics-host');
            return describe(host, 0, 4);
            """
        )
        print(tree)

    finally:
        driver.quit()


if __name__ == "__main__":
    main()
