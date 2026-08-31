import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/common/t_shadow_painter.dart';
import 'package:torugo_widgets/utils/t_adaptive_shapes.dart';

void main() {
  group('TShadowPainter', () {
    //
    // MARK: Defaults
    //
    group('Constructor & Defaults', () {
      test('Should use default values where no arguments are provided', () {
        final painter = TShadowPainter();

        expect(painter.color, equals(Color(0x80000000)));
        expect(painter.offset, equals(Offset.zero));
        expect(painter.blurRadius, equals(0.0));
        expect(painter.spreadRadius, equals(0.0));
        expect(painter.borderRadius, equals(0.0));
        expect(painter.borderShape, equals(TBorderShape.adaptive));
      });

      test('Should accept custom values where properties are provided', () {
        const color = Colors.green;
        const offset = Offset(10, 10);
        const blurRadius = 10.0;
        const borderRadius = 11.0;
        const borderShape = TBorderShape.superellipse;

        final painter = TShadowPainter(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          borderRadius: borderRadius,
          borderShape: borderShape,
        );

        expect(painter.color, equals(color));
        expect(painter.offset, equals(offset));
        expect(painter.blurRadius, equals(blurRadius));
        expect(painter.borderRadius, equals(borderRadius));
        expect(painter.borderShape, equals(borderShape));
      });

      test('Should throw an assertion error where blurRadius is negative', () {
        expect(
          () => TShadowPainter(blurRadius: -1.0),
          throwsA(isA<AssertionError>()),
        );
      });

      test(
        'Should throw an assertion error where spreadRadius is negative',
        () {
          expect(
            () => TShadowPainter(spreadRadius: -1.0),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'Should throw an assertion error where borderRadius is negative',
        () {
          expect(
            () => TShadowPainter(borderRadius: -1.0),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    });

    //
    // MARK: Should Repaint
    //
    group('Should Repaint', () {
      test('Should return false where properties are identical', () {
        final painter1 = TShadowPainter();
        final painter2 = TShadowPainter();

        expect(painter1.shouldRepaint(painter2), isFalse);
      });

      test('Should return true where color changes', () {
        final painter1 = TShadowPainter(color: Colors.green);
        final painter2 = TShadowPainter(color: Colors.yellow);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('Should return true where offset changes', () {
        final painter1 = TShadowPainter(offset: Offset(0, 0));
        final painter2 = TShadowPainter(offset: Offset(10, 10));

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('Should return true where blurRadius changes', () {
        final painter1 = TShadowPainter(blurRadius: 5.0);
        final painter2 = TShadowPainter(blurRadius: 10.0);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('Should return true where spreadRadius changes', () {
        final painter1 = TShadowPainter(spreadRadius: 5.0);
        final painter2 = TShadowPainter(spreadRadius: 10.0);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('Should return true where borderRadius changes', () {
        final painter1 = TShadowPainter(borderRadius: 5.0);
        final painter2 = TShadowPainter(borderRadius: 10.0);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });

      test('Should return true where borderShape changes', () {
        final painter1 = TShadowPainter(borderShape: TBorderShape.roundedRect);
        final painter2 = TShadowPainter(borderShape: TBorderShape.superellipse);

        expect(painter1.shouldRepaint(painter2), isTrue);
      });
    });

    //
    // MARK: Integration
    //
    group('Paint Widget Integration', () {
      testWidgets('Should render without error where default values are used', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CustomPaint(
                  size: Size(200, 100),
                  painter: TShadowPainter(),
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('Should render without error where custom values are used', (
        WidgetTester tester,
      ) async {
        for (final shape in TBorderShape.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CustomPaint(
                    size: Size(200, 100),
                    painter: TShadowPainter(
                      color: Colors.green,
                      offset: Offset(5, 5),
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                      borderRadius: 16.0,
                      borderShape: shape,
                    ),
                    child: Container(
                      width: 200,
                      height: 100,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(find.byType(Container), findsWidgets);
        }
      });
    });
  });
}
