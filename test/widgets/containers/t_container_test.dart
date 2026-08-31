import 'dart:ui';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

void main() {
  group('TContainer', () {
    test(
      'Should use documented default values where no arguments are provided',
      () {
        const container = TContainer();

        expect(container.width, isNull);
        expect(container.height, isNull);
        expect(container.minWidth, 0.0);
        expect(container.maxWidth, double.infinity);
        expect(container.minHeight, 0.0);
        expect(container.maxHeight, double.infinity);
        expect(container.clipBehavior, Clip.hardEdge);
        expect(container.borderShape, TBorderShape.adaptive);
        expect(container.borderRadius, 0.0);
        expect(container.borderSide, BorderSide.none);
        expect(container.margin, EdgeInsets.zero);
        expect(container.padding, EdgeInsets.zero);
        expect(container.alignment, Alignment.center);
        expect(container.color, isNull);
        expect(container.gradient, isNull);
        expect(container.decorationImage, isNull);
        expect(container.backgroundBlur, 0.0);
        expect(container.blendMode, isNull);
        expect(container.shadows, isEmpty);
        expect(container.child, isNull);
      },
    );

    test(
      'Should reject values where dimensions or visual values are negative',
      () {
        expect(() => TContainer(width: -1), throwsAssertionError);
        expect(() => TContainer(height: -1), throwsAssertionError);
        expect(() => TContainer(minWidth: -1), throwsAssertionError);
        expect(() => TContainer(maxWidth: -1), throwsAssertionError);
        expect(() => TContainer(minHeight: -1), throwsAssertionError);
        expect(() => TContainer(maxHeight: -1), throwsAssertionError);
        expect(() => TContainer(borderRadius: -1), throwsAssertionError);
        expect(() => TContainer(backgroundBlur: -1), throwsAssertionError);
      },
    );

    testWidgets(
      'Should pass layout and border properties where they are provided',
      (
        tester,
      ) async {
        const childKey = Key('child');
        const margin = EdgeInsets.all(4);
        const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
        const side = BorderSide(color: Colors.red, width: 2);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TContainer(
                width: 120,
                height: 80,
                minWidth: 20,
                maxWidth: 140,
                minHeight: 10,
                maxHeight: 100,
                margin: margin,
                padding: padding,
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.antiAlias,
                borderShape: TBorderShape.roundedRect,
                borderRadius: 12,
                borderSide: side,
                child: SizedBox(key: childKey, width: 10, height: 10),
              ),
            ),
          ),
        );

        final outerPadding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(TContainer),
            matching: find.byWidgetPredicate(
              (widget) => widget is Padding && widget.padding == margin,
            ),
          ),
        );
        final builtContainer = tester.widget<Container>(
          find.descendant(
            of: find.byType(TContainer),
            matching: find.byType(Container),
          ),
        );
        final align = tester.widget<Align>(
          find.descendant(
            of: find.byType(TContainer),
            matching: find.byType(Align),
          ),
        );
        final decoration = builtContainer.decoration! as ShapeDecoration;
        final border = decoration.shape as RoundedRectangleBorder;

        expect(outerPadding.padding, margin);
        expect(builtContainer.padding, padding);
        expect(builtContainer.clipBehavior, Clip.antiAlias);
        expect(
          builtContainer.constraints,
          const BoxConstraints(
            minWidth: 120,
            maxWidth: 120,
            minHeight: 80,
            maxHeight: 80,
          ),
        );
        expect(border.borderRadius, BorderRadius.circular(12));
        expect(border.side, side);
        expect(align.alignment, Alignment.bottomRight);
        expect(find.byKey(childKey), findsOneWidget);
      },
    );

    testWidgets(
      'Should build optional layers where blur, background, and shadows are provided',
      (
        tester,
      ) async {
        const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
        const shadow = BoxShadow(
          color: Colors.black,
          offset: Offset(2, 3),
          blurRadius: 4,
          spreadRadius: 2,
        );
        final decorationImage = DecorationImage(
          image: MemoryImage(
            Uint8List.fromList([71,73,70,56,57,97,1,0,1,0,128,0,0,0,0,0,255,255,255,44,0,0,0,0,1,0,1,0,0,2,1,76,0,59]),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 60,
                child: TContainer(
                  color: Colors.green,
                  gradient: gradient,
                  decorationImage: decorationImage,
                  backgroundBlur: 3,
                  blendMode: BlendMode.multiply,
                  shadows: [shadow],
                  borderRadius: 10,
                  borderShape: TBorderShape.superellipse,
                ),
              ),
            ),
          ),
        );

        final filter = tester.widget<BackdropFilter>(
          find.byType(BackdropFilter),
        );
        final background = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(TContainer),
            matching: find.byWidgetPredicate(
              (widget) => widget is DecoratedBox && widget.decoration is BoxDecoration,
            ),
          ),
        );
        final paint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(TContainer),
            matching: find.byWidgetPredicate(
              (widget) => widget is CustomPaint && widget.painter is TShadowPainter,
            ),
          ),
        );
        final decoration = background.decoration as BoxDecoration;
        final painter = paint.painter! as TShadowPainter;

        expect(filter.filter, isA<ImageFilter>());
        expect(decoration.color, Colors.green);
        expect(decoration.gradient, gradient);
        expect(decoration.image, decorationImage);
        expect(decoration.backgroundBlendMode, BlendMode.multiply);
        expect(painter.color, shadow.color);
        expect(painter.offset, shadow.offset);
        expect(painter.blurRadius, shadow.blurRadius);
        expect(painter.spreadRadius, shadow.spreadRadius);
        expect(painter.borderRadius, 10);
        expect(painter.borderShape, TBorderShape.superellipse);
      },
    );

    testWidgets(
      'Should omit optional layers where blur and shadows are not provided',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: TContainer())),
        );

        final container = find.byType(TContainer);
        expect(
          find.descendant(of: container, matching: find.byType(BackdropFilter)),
          findsNothing,
        );
        expect(
          find.descendant(
            of: container,
            matching: find.byWidgetPredicate(
              (widget) => widget is CustomPaint && widget.painter is TShadowPainter,
            ),
          ),
          findsNothing,
        );
      },
    );
  });
}
