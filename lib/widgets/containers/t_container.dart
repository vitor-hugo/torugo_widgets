// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

class TContainer extends StatelessWidget {
  const TContainer({
    this.width,
    this.height,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
    this.clipBehavior = Clip.hardEdge,
    this.borderShape = TBorderShape.adaptive,
    this.borderRadius = 0.0,
    this.borderSide = BorderSide.none,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.color,
    this.gradient,
    this.decorationImage,
    this.backgroundBlur = 0.0,
    this.blendMode,
    this.shadows = const [],
    this.child,
    super.key,
  }) : assert(width == null || width >= 0.0, 'Width must be non-negative'),
       assert(height == null || height >= 0.0, 'Height must be non-negative'),
       assert(minWidth >= 0.0, 'Minimum width must be non-negative'),
       assert(maxWidth >= 0.0, 'Maximum width must be non-negative'),
       assert(minHeight >= 0.0, 'Minimum height must be non-negative'),
       assert(maxHeight >= 0.0, 'Maximum height must be non-negative'),
       assert(borderRadius >= 0.0, 'Border radius must be non-negative'),
       assert(backgroundBlur >= 0.0, 'Background blur must be non-negative');

  /// The width of the container. If null the container will expand to fit its child. Defaults to [null].
  final double? width;

  /// The height of the container. If null the container will expand to fit its child. Defaults to [null].
  final double? height;

  /// Minimum width constraint for the container. Defaults to [0.0].
  final double minWidth;

  /// Maximum width constraint for the container. Defaults to [double.infinity].
  final double maxWidth;

  /// Minimum height constraint for the container. Defaults to [0.0].
  final double minHeight;

  /// Maximum height constraint for the container. Defaults to [double.infinity].
  final double maxHeight;

  /// The clip behavior of the container. Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// The border shape of the container. Defaults to [TBorderShape.adaptive].
  final TBorderShape borderShape;

  /// The circular border radius of the container. Defaults to [0.0].
  final double borderRadius;

  /// The border outline's color and weight.
  ///
  /// If [borderSide] is [BorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final BorderSide borderSide;

  /// Empty space to surround the container. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry margin;

  /// The amount of space by which to inset the child. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// Align the [child] within the container.
  final AlignmentGeometry alignment;

  /// The background color to paint behind the [child].
  final Color? color;

  /// The gradient to paint behind the [child]. If non-null, this will override [color].
  final Gradient? gradient;

  /// An image to paint above the background [color] or [gradient].
  final DecorationImage? decorationImage;

  /// The amount of blur to apply to the background of the container. Defaults to [0.0].
  final double backgroundBlur;

  /// The blend mode to apply to the background of the container. Defaults to [null].
  final BlendMode? blendMode;

  final List<BoxShadow> shadows;

  /// The [child] contained by the container.
  final Widget? child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
    properties.add(DoubleProperty('minWidth', minWidth, defaultValue: 0.0));
    properties.add(DoubleProperty('maxWidth', maxWidth, defaultValue: double.infinity));
    properties.add(DoubleProperty('minHeight', minHeight, defaultValue: 0.0));
    properties.add(DoubleProperty('maxHeight', maxHeight, defaultValue: double.infinity));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.hardEdge));
    properties.add(EnumProperty<TBorderShape>('borderShape', borderShape, defaultValue: TBorderShape.adaptive));
    properties.add(DoubleProperty('borderRadius', borderRadius, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<BorderSide>('borderSide', borderSide, defaultValue: BorderSide.none));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: EdgeInsets.zero));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: EdgeInsets.zero));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: Alignment.center));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<Gradient?>('gradient', gradient, defaultValue: null));
    properties.add(DiagnosticsProperty<DecorationImage?>('decorationImage', decorationImage, defaultValue: null));
    properties.add(DoubleProperty('backgroundBlur', backgroundBlur, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<BlendMode?>('blendMode', blendMode, defaultValue: null));
    properties.add(DiagnosticsProperty<List<BoxShadow>>('shadows', shadows, defaultValue: const []));
    super.debugFillProperties(properties);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Stack(
        clipBehavior: .none,
        children: [
          //
          // Background Blur
          //
          if (backgroundBlur > 0.0)
            Positioned.fill(
              child: TAdaptiveShapes.clipShape(
                radius: borderRadius,
                shape: borderShape,
                child: BackdropFilter(
                  filter: .blur(sigmaX: backgroundBlur, sigmaY: backgroundBlur, tileMode: .clamp),
                  child: SizedBox(),
                ),
              ),
            ),

          //
          // Shadows
          //
          if (shadows.isNotEmpty)
            _ShadowStack(
              shadows: shadows,
              borderRadius: borderRadius,
              borderShape: borderShape,
            ),

          //
          // Background
          //
          Positioned.fill(
            child: TAdaptiveShapes.clipShape(
              radius: borderRadius,
              shape: borderShape,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  gradient: gradient,
                  image: decorationImage,
                  backgroundBlendMode: blendMode,
                ),
              ),
            ),
          ),

          //
          // Child
          //
          Container(
            padding: padding,
            clipBehavior: clipBehavior,
            width: width,
            height: height,
            constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
              minHeight: minHeight,
              maxHeight: maxHeight,
            ),
            decoration: ShapeDecoration(
              shape: TAdaptiveShapes.shapeBorder(
                radius: borderRadius,
                side: borderSide,
                shape: borderShape,
              ),
            ),
            child: Align(
              alignment: alignment,
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShadowStack extends StatelessWidget {
  const new({required this.shadows, required this.borderRadius, required this.borderShape});

  final List<BoxShadow> shadows;
  final double borderRadius;
  final TBorderShape borderShape;

  @override
  Widget build(BuildContext context) {
    final List<Positioned> list = [];

    for (BoxShadow shadow in shadows) {
      list.add(
        Positioned.fill(
          child: CustomPaint(
            willChange: true,
            painter: TShadowPainter(
              color: shadow.color,
              offset: shadow.offset,
              blurRadius: shadow.blurRadius,
              spreadRadius: shadow.spreadRadius,
              borderRadius: borderRadius,
              borderShape: borderShape,
            ),
          ),
        ),
      );
    }

    return Positioned.fill(
      child: Stack(
        children: list,
      ),
    );
  }
}
