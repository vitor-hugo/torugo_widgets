import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

void main() {
  group('TCircularProgress', () {
    //
    // MARK: Constructor & Defaults
    //
    group('Constructor & Defaults', () {
      test('Should use default values where no arguments are provided', () {
        const progress = TCircularProgress();

        expect(progress.radius, 12.0);
        expect(progress.innerRadius, 2.7);
        expect(progress.ticks, 8);
        expect(progress.tickWeight, 8.0);
        expect(progress.animationDuration, const Duration(milliseconds: 850));
        expect(progress.color, isNull);
      });

      test('Should accept custom values where properties are provided', () {
        const progress = TCircularProgress(
          radius: 20,
          innerRadius: 4,
          ticks: 12,
          tickWeight: 5,
          animationDuration: Duration(seconds: 2),
          color: Colors.green,
        );

        expect(progress.radius, 20.0);
        expect(progress.innerRadius, 4.0);
        expect(progress.ticks, 12);
        expect(progress.tickWeight, 5.0);
        expect(progress.animationDuration, const Duration(seconds: 2));
        expect(progress.color, Colors.green);
      });

      test('Should reject invalid dimensions and tick values', () {
        expect(() => TCircularProgress(radius: 0), throwsAssertionError);
        expect(() => TCircularProgress(radius: -1), throwsAssertionError);
        expect(() => TCircularProgress(innerRadius: -1), throwsAssertionError);
        expect(
          () => TCircularProgress(radius: 10, innerRadius: 10),
          throwsAssertionError,
        );
        expect(() => TCircularProgress(ticks: 4), throwsAssertionError);
        expect(() => TCircularProgress(tickWeight: 1), throwsAssertionError);
      });
    });

    //
    // MARK: Widget Integration
    //
    group('Widget Integration', () {
      testWidgets('Should render at twice the configured radius', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: TCircularProgress(radius: 20)),
          ),
        );

        expect(
          tester.getSize(find.byType(TCircularProgress)),
          const Size.square(40),
        );
        expect(
          find.descendant(
            of: find.byType(TCircularProgress),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });

      testWidgets('Should animate and render custom values without error', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TCircularProgress(
                radius: 18,
                innerRadius: 3,
                ticks: 10,
                tickWeight: 6,
                animationDuration: Duration(milliseconds: 500),
                color: Colors.purple,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 250));

        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(TCircularProgress)),
          const Size.square(36),
        );
      });
    });
  });
}
