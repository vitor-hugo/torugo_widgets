import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torugo_widgets/torugo_widgets.dart';
import 'package:torugo_widgets/widgets/containers/t_animated_container.dart';

void main() {
  group('TAnimatedContainer', () {
    test('Should use documented default values where optional arguments are omitted', () {
      const widget = TAnimatedContainer(duration: Duration(milliseconds: 300));

      expect(widget.duration, const Duration(milliseconds: 300));
      expect(widget.curve, Curves.linear);
      expect(widget.onEnd, isNull);
      expect(widget.width, isNull);
      expect(widget.height, isNull);
      expect(widget.minWidth, 0.0);
      expect(widget.maxWidth, double.infinity);
      expect(widget.minHeight, 0.0);
      expect(widget.maxHeight, double.infinity);
      expect(widget.clipBehavior, Clip.hardEdge);
      expect(widget.borderShape, TBorderShape.adaptive);
      expect(widget.borderRadius, 0.0);
      expect(widget.borderSide, BorderSide.none);
      expect(widget.margin, EdgeInsets.zero);
      expect(widget.padding, EdgeInsets.zero);
      expect(widget.alignment, Alignment.topLeft);
      expect(widget.shadows, isEmpty);
      expect(widget.color, isNull);
      expect(widget.gradient, isNull);
      expect(widget.decorationImage, isNull);
      expect(widget.backgroundBlur, 0.0);
      expect(widget.blendMode, isNull);
      expect(widget.child, isNull);
    });

    test(
      'Should interpolate gradients where begin and end gradients are provided',
      () {
        const begin = LinearGradient(colors: [Colors.red, Colors.blue]);
        const end = LinearGradient(colors: [Colors.green, Colors.yellow]);
        final tween = GradientTween(begin: begin, end: end);

        expect(
          (tween.lerp(0.0)! as LinearGradient).colors,
          const [Color(0xFFF44336), Color(0xFF2196F3)],
        );
        expect(
          (tween.lerp(1.0)! as LinearGradient).colors,
          const [Color(0xFF4CAF50), Color(0xFFFFEB3B)],
        );

        final halfway = tween.lerp(0.5)! as LinearGradient;
        expect(halfway.colors, [
          Color.lerp(Colors.red, Colors.green, 0.5),
          Color.lerp(Colors.blue, Colors.yellow, 0.5),
        ]);
      },
    );

    testWidgets(
      'Should forward properties to TContainer where no animation is in progress',
      (tester) async {
        const childKey = Key('child');
        const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
        const shadow = BoxShadow(
          color: Colors.black,
          offset: Offset(2, 3),
          blurRadius: 4,
          spreadRadius: 1,
        );
        final decorationImage = DecorationImage(
          image: MemoryImage(
            Uint8List.fromList([
              71,
              73,
              70,
              56,
              57,
              97,
              1,
              0,
              1,
              0,
              128,
              0,
              0,
              0,
              0,
              0,
              255,
              255,
              255,
              44,
              0,
              0,
              0,
              0,
              1,
              0,
              1,
              0,
              0,
              2,
              1,
              76,
              0,
              59,
            ]),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TAnimatedContainer(
                duration: const Duration(seconds: 1),
                width: 120,
                height: 80,
                minWidth: 20,
                maxWidth: 140,
                minHeight: 10,
                maxHeight: 100,
                clipBehavior: Clip.antiAlias,
                borderShape: TBorderShape.superellipse,
                borderRadius: 12,
                borderSide: const BorderSide(color: Colors.red, width: 2),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.bottomRight,
                shadows: const [shadow],
                color: Colors.green,
                gradient: gradient,
                decorationImage: decorationImage,
                backgroundBlur: 3,
                blendMode: BlendMode.multiply,
                child: const SizedBox(key: childKey),
              ),
            ),
          ),
        );

        final container = tester.widget<TContainer>(find.byType(TContainer));

        expect(container.width, 120);
        expect(container.height, 80);
        expect(container.minWidth, 20);
        expect(container.maxWidth, 140);
        expect(container.minHeight, 10);
        expect(container.maxHeight, 100);
        expect(container.clipBehavior, Clip.antiAlias);
        expect(container.borderShape, TBorderShape.superellipse);
        expect(container.borderRadius, 12);
        expect(
          container.borderSide,
          const BorderSide(color: Colors.red, width: 2),
        );
        expect(container.margin, const EdgeInsets.all(4));
        expect(container.padding, const EdgeInsets.all(8));
        expect(container.alignment, Alignment.bottomRight);
        expect(container.shadows, const [shadow]);
        expect(container.color, Colors.green);
        expect(container.gradient, gradient);
        expect(container.decorationImage, decorationImage);
        expect(container.backgroundBlur, 3);
        expect(container.blendMode, BlendMode.multiply);
        expect(find.byKey(childKey), findsOneWidget);
      },
    );

    testWidgets(
      'Should interpolate animatable properties where the widget is rebuilt',
      (tester) async {
        const key = Key('animated-container');
        const beginGradient = LinearGradient(colors: [Colors.red, Colors.blue]);
        const endGradient = LinearGradient(
          colors: [Colors.green, Colors.yellow],
        );
        const beginShadow = BoxShadow(color: Colors.red, blurRadius: 2);
        const endShadow = BoxShadow(
          color: Colors.blue,
          offset: Offset(10, 4),
          blurRadius: 6,
          spreadRadius: 4,
        );

        Widget build({required bool end}) => MaterialApp(
          home: Scaffold(
            body: TAnimatedContainer(
              key: key,
              duration: const Duration(seconds: 1),
              width: end ? 200 : 100,
              height: end ? 100 : 50,
              borderRadius: end ? 20 : 4,
              borderSide: BorderSide(
                color: end ? Colors.blue : Colors.red,
                width: end ? 6 : 2,
              ),
              margin: EdgeInsets.all(end ? 10 : 2),
              padding: EdgeInsets.all(end ? 12 : 4),
              alignment: end ? Alignment.bottomRight : Alignment.topLeft,
              shadows: end ? const [endShadow] : const [beginShadow],
              color: end ? Colors.blue : Colors.red,
              gradient: end ? endGradient : beginGradient,
              backgroundBlur: end ? 10 : 2,
            ),
          ),
        );

        await tester.pumpWidget(build(end: false));
        await tester.pumpWidget(build(end: true));
        await tester.pump(const Duration(milliseconds: 500));

        final container = tester.widget<TContainer>(find.byType(TContainer));
        final gradient = container.gradient! as LinearGradient;

        expect(container.width, 150);
        expect(container.height, 75);
        expect(container.borderRadius, 12);
        expect(
          container.borderSide,
          BorderSide.lerp(
            const BorderSide(color: Colors.red, width: 2),
            const BorderSide(color: Colors.blue, width: 6),
            0.5,
          ),
        );
        expect(container.margin, const EdgeInsets.all(6));
        expect(container.padding, const EdgeInsets.all(8));
        expect(container.alignment, Alignment.center);
        expect(container.color, Color.lerp(Colors.red, Colors.blue, 0.5));
        expect(gradient.colors, [
          Color.lerp(Colors.red, Colors.green, 0.5),
          Color.lerp(Colors.blue, Colors.yellow, 0.5),
        ]);
        expect(container.backgroundBlur, 6);
        expect(
          container.shadows,
          BoxShadow.lerpList(const [beginShadow], const [endShadow], 0.5),
        );
      },
    );

    testWidgets('Should call onEnd where an animation completes', (
      tester,
    ) async {
      var completed = 0;
      const key = Key('animated-container');

      Widget build(double width) => MaterialApp(
        home: Scaffold(
          body: TAnimatedContainer(
            key: key,
            duration: const Duration(milliseconds: 100),
            width: width,
            onEnd: () => completed++,
          ),
        ),
      );

      await tester.pumpWidget(build(100));
      await tester.pumpWidget(build(200));
      await tester.pumpAndSettle();

      expect(completed, 1);
    });
  });
}
