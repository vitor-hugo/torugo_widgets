import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:twidgets/twidgets.dart';

void main() {
  group('TAdaptiveShapes', () {
    //
    // MARK: Shape Border
    //
    group('shapeBorder', () {
      test('Should return default values where no arguments are provided', () {
        final shapeBorder = TAdaptiveShapes.shapeBorder();

        if (TPlatform.isApple) {
          expect(shapeBorder, isA<RoundedSuperellipseBorder>());
        } else {
          expect(shapeBorder, isA<RoundedRectangleBorder>());
        }

        final border = TPlatform.isApple
            ? shapeBorder as RoundedSuperellipseBorder
            : shapeBorder as RoundedRectangleBorder;

        expect(border.borderRadius, equals(BorderRadius.circular(0.0)));
        expect(border.side, equals(BorderSide.none));
      });

      test('Should return the requested shape where a shape is forced', () {
        final superellipseBorder = TAdaptiveShapes.shapeBorder(
          shape: TBorderShape.superellipse,
        );
        final roundedRectBorder = TAdaptiveShapes.shapeBorder(
          shape: TBorderShape.roundedRect,
        );

        expect(superellipseBorder, isA<RoundedSuperellipseBorder>());
        expect(roundedRectBorder, isA<RoundedRectangleBorder>());
      });

      test('Should apply radius and side where they are provided', () {
        final radius = 10.0;
        final side = const BorderSide(color: Colors.red, width: 2.0);

        final shapeBorder = TAdaptiveShapes.shapeBorder(
          radius: radius,
          side: side,
        );
        final border = TPlatform.isApple
            ? shapeBorder as RoundedSuperellipseBorder
            : shapeBorder as RoundedRectangleBorder;

        expect(border.borderRadius, equals(BorderRadius.circular(radius)));
        expect(border.side, equals(side));
      });

      test(
        'Should clamp radius to zero where a negative radius is provided',
        () {
          final shapeBorder = TAdaptiveShapes.shapeBorder(radius: -10.0);
          final border = TPlatform.isApple
              ? shapeBorder as RoundedSuperellipseBorder
              : shapeBorder as RoundedRectangleBorder;

          expect(border.borderRadius, BorderRadius.zero);
        },
      );
    });

    //
    // MARK: Outlined Border
    //
    // `outlinedBorder()` is tested indirectly through shapeBorder.
    group('outlinedBorder', () {
      test('Should return default values where no arguments are provided', () {
        final outlinedBorder = TAdaptiveShapes.outlinedBorder();
        expect(outlinedBorder, isA<OutlinedBorder>());

        final border = TPlatform.isApple
            ? outlinedBorder as RoundedSuperellipseBorder
            : outlinedBorder as RoundedRectangleBorder;

        expect(border.borderRadius, equals(BorderRadius.circular(0.0)));
        expect(border.side, equals(BorderSide.none));
      });

      test('Should forward properties where a shape is forced', () {
        const side = BorderSide(color: Colors.blue, width: 3.0);
        final border = TAdaptiveShapes.outlinedBorder(
          radius: 8.0,
          side: side,
          shape: TBorderShape.superellipse,
        );

        expect(border, isA<RoundedSuperellipseBorder>());
        expect(
          (border as RoundedSuperellipseBorder).borderRadius,
          BorderRadius.circular(8.0),
        );
        expect(border.side, side);
      });
    });

    //
    // MARK: Clip Shape
    //
    group('clipShape', () {
      test('Should return default values where no arguments are provided', () {
        final clipShape = TAdaptiveShapes.clipShape();

        if (TPlatform.isApple) {
          final clip = clipShape as ClipRSuperellipse;
          expect(clip.borderRadius, equals(BorderRadius.circular(0.0)));
          expect(clip.clipBehavior, equals(Clip.antiAlias));
        } else {
          final clip = clipShape as ClipRRect;
          expect(clip.borderRadius, equals(BorderRadius.circular(0.0)));
          expect(clip.clipBehavior, equals(Clip.antiAlias));
        }
      });
    });

    test('Should return the requested shape where a shape is forced', () {
      final superellipseClip = TAdaptiveShapes.clipShape(
        shape: TBorderShape.superellipse,
      );
      final roundedRectClip = TAdaptiveShapes.clipShape(
        shape: TBorderShape.roundedRect,
      );

      expect(superellipseClip, isA<ClipRSuperellipse>());
      expect(roundedRectClip, isA<ClipRRect>());
    });

    test('Should apply properties where they are provided', () {
      final radius = 10.0;
      final clipBehavior = Clip.hardEdge;

      final clipShape = TAdaptiveShapes.clipShape(
        radius: radius,
        clipBehavior: clipBehavior,
      );

      if (TPlatform.isApple) {
        final clip = clipShape as ClipRSuperellipse;
        expect(clip.borderRadius, equals(BorderRadius.circular(radius)));
        expect(clip.clipBehavior, equals(clipBehavior));
      } else {
        final clip = clipShape as ClipRRect;
        expect(clip.borderRadius, equals(BorderRadius.circular(radius)));
        expect(clip.clipBehavior, equals(clipBehavior));
      }
    });

    test('Should forward the child where one is provided', () {
      const child = SizedBox(key: Key('child'));
      final clipShape = TAdaptiveShapes.clipShape(
        radius: -10.0,
        shape: TBorderShape.roundedRect,
        child: child,
      ) as ClipRRect;

      expect(clipShape.borderRadius, BorderRadius.zero);
      expect(clipShape.child, child);
    });
  });
}
