import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

void main() {
  group('TColor', () {
    //
    // MARK: From HSLA
    //
    group('fromHSLA', () {
      test('Should create a color with the requested hue and alpha', () {
        final color = TColor.fromHSLA(120, 1, 0.5, 0.5);

        expect(color.toARGB32(), 0x8000FF00);
      });

      test('Should support transparent and opaque alpha values', () {
        expect(TColor.fromHSLA(240, 1, 0.5, 0), const Color(0x000000FF));
        expect(TColor.fromHSLA(240, 1, 0.5, 1), const Color(0xFF0000FF));
      });
    });

    //
    // MARK: From HSL
    //
    group('fromHSL', () {
      test(
        'Should create opaque colors from hue, saturation and lightness',
        () {
          expect(TColor.fromHSL(0, 1, 0.5), const Color(0xFFFF0000));
          expect(TColor.fromHSL(120, 1, 0.5), const Color(0xFF00FF00));
          expect(TColor.fromHSL(240, 1, 0.5), const Color(0xFF0000FF));
        },
      );

      test('Should create grayscale colors where saturation is zero', () {
        expect(TColor.fromHSL(120, 0, 0.5), const Color(0xFF808080));
      });

      test('Should support the lightness boundaries', () {
        expect(TColor.fromHSL(120, 1, 0), const Color(0xFF000000));
        expect(TColor.fromHSL(120, 1, 1), const Color(0xFFFFFFFF));
      });

      test('Should return the same color at both hue boundaries', () {
        expect(TColor.fromHSL(360, 1, 0.5), TColor.fromHSL(0, 1, 0.5));
      });
    });

    //
    // MARK: From Hex
    //
    group('fromHex', () {
      test('Should default to full opacity where six digits are provided', () {
        expect(TColor.fromHex('FF5733'), const Color(0xFFFF5733));
        expect(TColor.fromHex('#FF5733'), const Color(0xFFFF5733));
      });

      test('Should preserve alpha where eight digits are provided', () {
        expect(TColor.fromHex('80FF5733'), const Color(0x80FF5733));
        expect(TColor.fromHex('#80FF5733'), const Color(0x80FF5733));
        expect(TColor.fromHex('00FF5733'), const Color(0x00FF5733));
      });

      test('Should accept lowercase and mixed-case hex digits', () {
        expect(TColor.fromHex('ff5733'), const Color(0xFFFF5733));
        expect(TColor.fromHex('#80fF5733'), const Color(0x80FF5733));
      });

      test('Should trim surrounding whitespace', () {
        expect(TColor.fromHex('  FF5733  '), const Color(0xFFFF5733));
        expect(TColor.fromHex('  #80FF5733  '), const Color(0x80FF5733));
      });

      test('Should throw where the number of digits is invalid', () {
        for (final hex in ['', '#', 'FFF', '12345', '1234567', '123456789']) {
          expect(() => TColor.fromHex(hex), throwsFormatException);
        }
      });

      test('Should throw where the value contains invalid hex digits', () {
        expect(() => TColor.fromHex('GG5733'), throwsFormatException);
        expect(() => TColor.fromHex('#80FF573Z'), throwsFormatException);
      });
    });
  });
}
