# semantics

A small Flutter web app (login, dashboard, employee management) built to be **testable**, together with a Selenium + pytest end-to-end suite. It shows how Flutter's `Semantics` makes a canvas-rendered app easy to automate.

## What's inside

- **Flutter app** (`lib/`): login, dashboard and employee pages, with services for auth and employees.
- **Testable widgets** (`lib/widgets/`): `TestableButton` and `TestableTextField` wrap standard widgets with semantic identifiers, so Selenium can find them in the DOM.
- **E2E suite** (`e2e/`): Selenium (Chrome) tests using the Page Object pattern, with failure screenshots.

```
lib/
├── models/employee.dart
├── pages/            # login, dashboard, employee
├── services/         # auth_service, employee_service
├── widgets/          # testable_button, testable_text_field
└── main.dart
e2e/
├── pages/            # base, login, dashboard, employee page objects
├── tests/            # test_login, test_employee, test_validation
├── tools/dump_dom.py # inspect the semantics DOM
├── utils/driver.py   # Chrome driver setup
└── conftest.py       # fixtures, screenshot-on-failure hook
```

## Getting started

### 1. Run the app

```bash
flutter pub get
flutter run -d chrome --web-port=3000
```

### 2. Run the E2E tests

The app must already be running on `http://localhost:3000`. You can override that with the `E2E_BASE_URL` environment variable.

```bash
pip install -r e2e/requirements.txt
pytest -v
```

`pytest.ini` points at `e2e/tests`, so you can run it from the repo root. Failure screenshots are saved to `e2e/screenshots/`. Requires Chrome.

## Tech stack

Flutter Web (Dart ^3.11), Python, Selenium 4, pytest, pytest-html.
