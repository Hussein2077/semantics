import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // The browser-side semantics DOM (flt-semantics-host and its flt-semantics
  // children) is only populated when Flutter's accessibility bridge is on.
  // Assistive technologies (screen readers) switch it on automatically, but
  // Selenium is not an assistive technology, so we enable it explicitly.
  // Without this line, Semantics(identifier: ...) would never reach the DOM.
  SemanticsBinding.instance.ensureSemantics();

  runApp(const SemanticsApp());
}
