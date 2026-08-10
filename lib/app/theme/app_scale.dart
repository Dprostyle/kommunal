import 'package:flutter/widgets.dart';

/// Keeps typography visually consistent across phone sizes / OS font settings.
///
/// Design reference: typical modern phone logical width (~390).
/// Clamps extremes so Android/iOS accessibility text scale cannot blow up the UI.
abstract final class AppScale {
  static const double designWidth = 390;

  /// Mild width-relative factor; avoids tiny/huge text on narrow/wide phones.
  static double layoutOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / designWidth).clamp(0.90, 1.08);
  }

  /// Prefer this at the app root via [MediaQuery.textScaler].
  static TextScaler textScalerOf(BuildContext context) {
    final mq = MediaQuery.of(context);
    final design = layoutOf(context);
    // Flatten OS text scale extremes, then apply design-relative factor.
    final os = mq.textScaler.scale(1).clamp(0.95, 1.05);
    return TextScaler.linear((design * os).clamp(0.90, 1.10));
  }
}
