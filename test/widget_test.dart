// Widget tests that verify the app builds and that every Selenium hook is
// present as a Semantics identifier. The real E2E verification happens in
// e2e/ with Python + Selenium against the running web app.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:semantics/app.dart';

void main() {
  group('login page semantics', () {
    testWidgets('login screen exposes the required identifiers',
        (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const SemanticsApp());
      await tester.pump();

      expect(find.bySemanticsIdentifier('login_username'), findsOneWidget);
      expect(find.bySemanticsIdentifier('login_password'), findsOneWidget);
      expect(find.bySemanticsIdentifier('login_button'), findsOneWidget);
      expect(find.bySemanticsIdentifier('dashboard'), findsNothing);

      handle.dispose();
    });

    testWidgets('submitting an empty form shows field error identifiers',
        (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const SemanticsApp());
      await tester.pump();

      await tester.tap(find.bySemanticsIdentifier('login_button'));
      await tester.pump();

      expect(find.bySemanticsIdentifier('login_username_error'),
          findsOneWidget);
      expect(find.bySemanticsIdentifier('login_password_error'),
          findsOneWidget);

      handle.dispose();
    });
  });
}
