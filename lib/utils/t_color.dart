import 'package:flutter/widgets.dart';

final class TColor {
  TColor._();

  /// Create an sRGB color from hue, saturation, lightness and alpha.
  ///
  /// * `h` is hue, from 0.0 to 360.0.
  /// * `s` is saturation, from 0.0 to 1.0.
  /// * `l` is lightness, from 0.0 to 1.0.
  /// * `a` is alpha, from 0.0 to 1.0.
  static Color fromHSLA(double h, double s, double l, double a) {
    return HSLColor.fromAHSL(a, h, s, l).toColor();
  }

  /// Create an sRGB color from hue, saturation and lightness.
  ///
  /// * `h` is hue, from 0.0 to 360.0.
  /// * `s` is saturation, from 0.0 to 1.0.
  /// * `l` is lightness, from 0.0 to 1.0.
  static Color fromHSL(double h, double s, double l) {
    return HSLColor.fromAHSL(1.0, h, s, l).toColor();
  }

  /// Create an sRGB color from a hex color value.
  ///
  /// Supports:
  /// * 6 digits (e.g., "FF5733" or "#FF5733") -> defaults to full opacity (FF)
  /// * 8 digits (e.g., "80FF5733" or "#80FF5733") -> includes alpha channel
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    final cleanHex = hexString.replaceFirst('#', '').trim();

    if (cleanHex.length == 6) {
      buffer.write('FF'); // Add default alpha if missing
    } else if (cleanHex.length != 8) {
      throw FormatException('Invalid hex color format: "$hexString". Expected 6 or 8 characters.');
    }

    buffer.write(cleanHex);

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
