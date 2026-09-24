import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

void main() {
  group('TColorExtension', () {
    const color = Color(0xFF336699);

    //
    // MARK: HSL Values
    //
    group('HSL Values', () {
      test('Should expose the HSL values of the color', () {
        final hsl = HSLColor.fromColor(color);

        expect(color.toHSL, hsl);
        expect(color.hue, hsl.hue);
        expect(color.saturation, hsl.saturation);
        expect(color.lightness, hsl.lightness);
      });

      test('Should set individual HSL values', () {
        expect(color.setHue(120).hue, closeTo(120, 0.01));
        expect(color.setSaturation(0.25).saturation, closeTo(0.25, 0.01));
        expect(color.setLightness(0.75).lightness, closeTo(0.75, 0.01));
      });

      test('Should clamp HSL values where they exceed their ranges', () {
        expect(color.setHue(-1).hue, closeTo(0, 0.01));
        expect(color.setHue(361).hue, closeTo(0, 0.01));
        expect(color.setSaturation(-1).saturation, closeTo(0, 0.01));
        expect(color.setSaturation(2).saturation, closeTo(1, 0.01));
        expect(color.setLightness(-1).lightness, closeTo(0, 0.01));
        expect(color.setLightness(2).lightness, closeTo(1, 0.01));
      });
    });

    //
    // MARK: Adjustments
    //
    group('Adjustments', () {
      test('Should adjust hue and wrap around the color wheel', () {
        expect(color.setHue(350).adjustHue(20).hue, closeTo(10, 0.01));
        expect(color.setHue(10).adjustHue(-20).hue, closeTo(350, 0.01));
      });

      test('Should adjust saturation and clamp the result', () {
        expect(
          color.setSaturation(0.5).adjustSaturation(0.2).saturation,
          closeTo(0.7, 0.01),
        );
        expect(color.adjustSaturation(2).saturation, closeTo(1, 0.01));
        expect(color.adjustSaturation(-2).saturation, closeTo(0, 0.01));
      });

      test('Should adjust lightness and clamp the result', () {
        expect(
          color.setLightness(0.5).adjustLightness(0.2).lightness,
          closeTo(0.7, 0.01),
        );
        expect(color.adjustLightness(2).lightness, closeTo(1, 0.01));
        expect(color.adjustLightness(-2).lightness, closeTo(0, 0.01));
      });

      test('Should darken and lighten by the absolute amount', () {
        expect(color.darken().lightness, closeTo(color.lightness - 0.1, 0.01));
        expect(
          color.darken(-0.2).lightness,
          closeTo(color.lightness - 0.2, 0.01),
        );
        expect(color.lighten().lightness, closeTo(color.lightness + 0.1, 0.01));
        expect(
          color.lighten(-0.2).lightness,
          closeTo(color.lightness + 0.2, 0.01),
        );
      });

      test('Should set and clamp alpha', () {
        expect(color.setAlpha(0.5).a, closeTo(0.5, 0.001));
        expect(color.setAlpha(-1).a, 0.0);
        expect(color.setAlpha(2).a, 1.0);
      });
    });

    //
    // MARK: Derived Colors
    //
    group('Derived Colors', () {
      test('Should return the opposite hue for the complementary color', () {
        expect(color.complementary.hue, closeTo((color.hue + 180) % 360, 0.01));
      });

      test('Should return a contrasting on-color', () {
        expect(Colors.white.onColor, const Color(0xFF131313));
        expect(Colors.black.onColor, const Color(0xFFF7F7F7));
      });

      test('Should return the documented tonal foreground', () {
        expect(color.foreground.lightness, closeTo(0.1, 0.01));
        expect(color.foreground.saturation, closeTo(0.3, 0.01));
      });

      test('Should create a material swatch from the color', () {
        final swatch = color.toMaterialColor();

        expect(swatch.toARGB32(), color.hashCode);
        expect(swatch[500], color);
        expect(swatch[50]!.lightness, greaterThan(color.lightness));
        expect(swatch[900]!.lightness, lessThan(color.lightness));
        expect(
          swatch.keys,
          containsAll(<int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900]),
        );
      });
    });
  });
}
