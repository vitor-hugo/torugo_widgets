// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/utils/t_adaptive_shapes.dart';

class TShadowPainter extends CustomPainter with Diagnosticable {
  const new({
    this.color = const Color(0x80000000),
    this.offset = Offset.zero,
    this.blurRadius = 0.0,
    this.spreadRadius = 0.0,
    this.borderRadius = 0.0,
    this.borderShape = .adaptive,
  }) : assert(blurRadius >= 0.0, "'blurRadius' must be non-negative."),
       assert(spreadRadius >= 0.0, "'spreadRadius' must be non-negative."),
       assert(borderRadius >= 0.0, "'borderRadius' must be non-negative.");

  final Color color;
  final Offset offset;
  final double blurRadius;
  final double spreadRadius;
  final double borderRadius;
  final TBorderShape borderShape;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(ColorProperty('color', color, defaultValue: Color(0x00000000)));
    properties.add(DiagnosticsProperty<Offset>('offset', offset, defaultValue: Offset.zero));
    properties.add(DoubleProperty('blurRadius', blurRadius, defaultValue: 0.0));
    properties.add(DoubleProperty('spreadRadius', spreadRadius, defaultValue: 0.0));
    properties.add(DoubleProperty('borderRadius', borderRadius, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<TBorderShape>('borderShape', borderShape, defaultValue: TBorderShape.adaptive));

    super.debugFillProperties(properties);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final shape = TAdaptiveShapes.shapeBorder(radius: borderRadius, shape: borderShape);

    final Rect rect = Offset.zero & size;
    Path widgetPath = shape.getOuterPath(rect);
    Path shadowPath = _resolveShadowPath(widgetPath, rect);

    canvas.save();

    final double maxInflate = 100 + blurRadius + spreadRadius.abs();
    final Path clipPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect.inflate(maxInflate)),
      widgetPath,
    );
    canvas.clipPath(clipPath);

    final Paint shadowPaint = Paint()
      ..color = _resolveShadowColor()
      ..maskFilter = .blur(BlurStyle.normal, blurRadius);

    canvas.drawPath(shadowPath.shift(offset), shadowPaint);
    canvas.restore();

    final Paint fillPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.drawPath(widgetPath, fillPaint);
  }

  Path _resolveShadowPath(Path path, Rect rect) {
    if (spreadRadius == 0.0) return path;

    final Rect spreadRect = rect.inflate(spreadRadius);
    final double adjustedRadius = (borderRadius + spreadRadius).clamp(0.0, double.infinity);
    final ShapeBorder spreadShape = TAdaptiveShapes.shapeBorder(
      radius: adjustedRadius,
      shape: borderShape,
    );

    return spreadShape.getOuterPath(spreadRect);
  }

  Color _resolveShadowColor() {
    return offset == Offset.zero && blurRadius == 0.0 && spreadRadius == 0.0 ? Color(0x00000000) : color;
  }

  @override
  bool shouldRepaint(TShadowPainter old) {
    return old.color != color ||
        old.offset != offset ||
        old.blurRadius != blurRadius ||
        old.spreadRadius != spreadRadius ||
        old.borderRadius != borderRadius ||
        old.borderShape != borderShape;
  }
}
