// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class const TCircularProgress({
  /// The radius of the circular progress. Defaults to `12`.
  final double radius = 12,

  /// The inner radius of the circular progress. Defaults to `2.7`.
  final double innerRadius = 2.7,

  /// The number of ticks. Defaults to `8`.
  final int ticks = 8,

  /// The weight of a tick. Defaults to `8`.
  final double tickWeight = 8,

  /// The duration of a complete rotation.
  final Duration animationDuration = const Duration(milliseconds: 850),

  /// The color of the ticks. Defaults to `ColorScheme.onSurface`.
  final Color? color,

  super.key,
}) extends StatefulWidget {
  this
    : assert(radius > 0.0, 'Radius must be non-negative.'),
      assert(innerRadius >= 0.0, 'innerRadius must be equal or greater than zero.'),
      assert(radius > innerRadius, 'Radius must be greater than innerRadius'),
      assert(ticks >= 5, "The minimum number of ticks is five."),
      assert(tickWeight >= 2, "The minimum weight of a tick is 2.");

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DoubleProperty('radius', radius, defaultValue: 12));
    properties.add(DoubleProperty('innerRadius', innerRadius, defaultValue: 2.7));
    properties.add(IntProperty('ticks', ticks, defaultValue: 8));
    properties.add(DoubleProperty('tickWeight', tickWeight, defaultValue: 8));
    properties.add(
      DiagnosticsProperty<Duration>(
        'animationDuration',
        animationDuration,
        defaultValue: const Duration(milliseconds: 850),
      ),
    );
    properties.add(ColorProperty('color', color, defaultValue: null));

    super.debugFillProperties(properties);
  }

  @override
  State<TCircularProgress> createState() => _TCircularProgressState();
}

class _TCircularProgressState extends State<TCircularProgress> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: widget.animationDuration, vsync: this);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = widget.color ?? colorScheme.onSurface;

    return SizedBox.square(
      dimension: widget.radius * 2,
      child: CustomPaint(
        painter: _TCircularProgressPainter(
          animation: _animationController,
          radius: widget.radius,
          innerRadius: widget.innerRadius,
          ticks: widget.ticks,
          tickWeight: widget.tickWeight,
          color: effectiveColor,
        ),
      ),
    );
  }
}

class _TCircularProgressPainter({
  required final Animation<double> animation,
  required final double radius,
  required final double innerRadius,
  required final int ticks,
  required final double tickWeight,
  required final Color color,
}) extends CustomPainter {
  final RRect tickFundamentalShape;

  this
    : tickFundamentalShape = RRect.fromLTRBXY(
        -radius / tickWeight.toDouble(),
        -radius / innerRadius,
        radius / tickWeight.toDouble(),
        -radius * 1,
        radius,
        radius,
      ),
      super(repaint: animation);

  final _twoPI = math.pi * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final List<Color> colors = _resolveTickColors(color, ticks);
    final int tickCount = colors.length;

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (tickCount * animation.value).floor();

    for (int i = 0; i < tickCount; ++i) {
      final int t = (i - activeTick) % tickCount;
      paint.color = colors[t];
      canvas.drawRRect(tickFundamentalShape, paint);
      canvas.rotate(_twoPI / tickCount);
    }

    canvas.restore();
  }

  List<Color> _resolveTickColors(Color color, int ticks) {
    double progression = 0.94 / ticks;
    double alpha = progression;
    final List<Color> colors = [];
    final relativeAlpha = 255 * color.a;

    for (var i = 0; i < ticks; i++) {
      colors.add(color.withAlpha((relativeAlpha * alpha).floor()));
      alpha += progression;
    }

    return colors;
  }

  @override
  bool shouldRepaint(_TCircularProgressPainter old) {
    return old.animation != animation || old.color != color;
  }
}
