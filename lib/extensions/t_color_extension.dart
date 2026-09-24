// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:material_ui/material_ui.dart';

extension TColorExtension on Color {
  /// Converts the color to HSL.
  HSLColor get toHSL => HSLColor.fromColor(this);

  /// Current hue value
  double get hue => toHSL.hue;

  /// Current saturation value
  double get saturation => toHSL.saturation;

  /// Current lightness
  double get lightness => toHSL.lightness;

  /// Sets the [hue] of the color.
  /// The value must be in the range [0.0, 360.0].
  Color setHue(double hue) {
    final hsl = toHSL;
    return hsl.withHue(hue.clamp(0.0, 360.0)).toColor();
  }

  /// Sets the [saturation] of the color.
  /// The value must be in the range [0.0, 1.0].
  Color setSaturation(double saturation) {
    final hsl = toHSL;
    return hsl.withSaturation(saturation.clamp(0.0, 1.0)).toColor();
  }

  /// Sets the [lightness] of the color.
  /// The value must be in the range [0.0, 1.0].
  Color setLightness(double lightness) {
    final hsl = toHSL;
    return hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
  }

  /// Adjusts the [hue] of the color by the given [amount].
  /// The amount must be in the range [-360.0, 360.0].
  Color adjustHue(double amount) {
    final hsl = toHSL;
    final newHue = (hsl.hue + amount) % 360.0;
    return hsl.withHue(newHue < 0 ? newHue + 360.0 : newHue).toColor();
  }

  /// Adjusts the [saturation] of the color by the given [amount].
  /// The amount must be in the range [-1.0, 1.0].
  Color adjustSaturation(double amount) {
    final hsl = toHSL;
    final newSaturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    return hsl.withSaturation(newSaturation).toColor();
  }

  /// Adjusts the [lightness] of the color by the given [amount].
  /// The amount must be in the range [-1.0, 1.0].
  Color adjustLightness(double amount) {
    final hsl = toHSL;
    final newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// Darkens the color by the given [amount].
  Color darken([double amount = 0.1]) => adjustLightness(-amount.abs());

  /// Lightens the color by the given [amount].
  Color lighten([double amount = 0.1]) => adjustLightness(amount.abs());

  /// Sets the [alpha] of the color.
  /// The value must be in the range [0.0, 1.0].
  Color setAlpha(double alpha) {
    return withValues(alpha: alpha.clamp(0.0, 1.0));
  }

  /// Gets the [complementary] color.
  ///
  /// It is the color opposite to the current color on the color wheel.
  Color get complementary => adjustHue(180.0);

  /// Gets a Black/White (ish) color that best contrasts the current color.
  ///
  /// It is the color that should be used for text or icons placed on top of the current color.
  Color get onColor => computeLuminance() > 0.179 ? const Color(0xFF131313) : const Color(0xFFF7F7F7);

  /// Different from [onColor], it is a darken/lighten version of the current color,
  /// like a tonal variant.
  Color get foreground {
    if (computeLuminance() > 0.179) {
      return setLightness(0.1).setSaturation(0.3);
    } else {
      return setLightness(0.1).setSaturation(0.3);
    }
  }

  /// Creates a [MaterialColor] swatch.
  ///
  /// The [swatchLightness] is the lightness of the
  /// [500] color in the swatch, which is the current color.
  MaterialColor toMaterialColor({int swatchLightness = 50}) {
    return MaterialColor(
      hashCode,
      {
        50: lighten(swatchLightness / 1000),
        100: lighten(swatchLightness / 200),
        200: lighten(swatchLightness / 100),
        300: lighten(swatchLightness / 50),
        400: lighten(swatchLightness / 25),
        500: this,
        600: darken(swatchLightness / 25),
        700: darken(swatchLightness / 50),
        800: darken(swatchLightness / 100),
        900: darken(swatchLightness / 200),
      },
    );
  }
}
