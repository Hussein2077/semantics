import 'package:flutter/material.dart';

/// A Material button wrapped in a [Semantics] node carrying a stable
/// [identifier] so Selenium can locate and click it regardless of how the
/// visual UI is styled.
class TestableButton extends StatelessWidget {
  const TestableButton({
    super.key,
    required this.identifier,
    required this.label,
    this.onPressed,
  });

  /// Stable test hook. On Flutter Web this ends up as the
  /// `flt-semantics-identifier` attribute of the semantics DOM element.
  final String identifier;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // `button: true` gives this Semantics node real semantic information of
    // its own. Without it, an identifier-only wrapper can be pruned during
    // semantics compilation when it sits inside another Semantics container
    // (e.g. a page-level container), losing the identifier in the DOM.
    return Semantics(
      identifier: identifier,
      button: true,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
