// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

class TAnimatedContainer extends ImplicitlyAnimatedWidget {
  const TAnimatedContainer({
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,

    this.width,
    this.height,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
    this.clipBehavior = Clip.hardEdge,
    this.borderShape = .adaptive,
    this.borderRadius = 0.0,
    this.borderSide = BorderSide.none,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topLeft,
    this.shadows = const [],
    this.color,
    this.gradient,
    this.decorationImage,
    this.backgroundBlur = 0.0,
    this.blendMode,
    this.child,
    super.key,
  });

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
    super.debugFillProperties(properties);

    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
    properties.add(DoubleProperty('minWidth', minWidth, defaultValue: 0.0));
    properties.add(DoubleProperty('maxWidth', maxWidth, defaultValue: double.infinity));
    properties.add(DoubleProperty('minHeight', minHeight, defaultValue: 0.0));
    properties.add(DoubleProperty('maxHeight', maxHeight, defaultValue: double.infinity));
    properties.add(DiagnosticsProperty<Clip?>('clipBehavior', clipBehavior, defaultValue: Clip.hardEdge));
    properties.add(EnumProperty<TBorderShape>('borderShape', borderShape, defaultValue: TBorderShape.adaptive));
    properties.add(DoubleProperty('borderRadius', borderRadius, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<BorderSide?>('borderSide', borderSide, defaultValue: BorderSide.none));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: EdgeInsets.zero));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: EdgeInsets.zero));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: Alignment.topLeft));
    properties.add(DiagnosticsProperty<List<BoxShadow>>('shadows', shadows, defaultValue: []));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient, defaultValue: null));
    properties.add(DiagnosticsProperty<DecorationImage>('decorationImage', decorationImage, defaultValue: null));
    properties.add(DoubleProperty('backgroundBlur', backgroundBlur, defaultValue: 0.0));
    properties.add(DiagnosticsProperty<BlendMode>('blendMode', blendMode, defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>('duration', duration, defaultValue: null));
    properties.add(DiagnosticsProperty<Curve>('curve', curve, defaultValue: Curves.linear));
    properties.add(DiagnosticsProperty<void Function()>('onEnd', onEnd, defaultValue: Curves.linear));
  }

  @override
  AnimatedWidgetBaseState<TAnimatedContainer> createState() => _TAnimatedContainerState();
}

/// A [Tween] for interpolating between two [Gradient]s.
class GradientTween extends Tween<Gradient?> {
  GradientTween({super.begin, super.end});

  @override
  Gradient? lerp(double t) => Gradient.lerp(begin, end, t);
}

class _TAnimatedContainerState extends AnimatedWidgetBaseState<TAnimatedContainer> {
  Tween<double?>? _width;
  Tween<double?>? _height;
  Tween<double?>? _borderRadius;
  _BorderSideTween? _borderSide;
  Tween<double?>? _backgroundBlur;
  ColorTween? _color;
  GradientTween? _gradient;
  EdgeInsetsGeometryTween? _margin;
  EdgeInsetsGeometryTween? _padding;
  AlignmentGeometryTween? _alignment;
  _BoxShadowListTween? _shadows;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    T? interpolate<T extends Tween<dynamic>>(
      Tween<dynamic>? tween,
      dynamic target,
      Tween<dynamic> Function(dynamic) builder,
    ) => visitor(tween, target, builder) as T?;

    _width = interpolate(_width, widget.width, (v) => Tween<double>(begin: v as double?));
    _height = interpolate(_height, widget.height, (v) => Tween<double>(begin: v as double?));
    _borderRadius = interpolate(_borderRadius, widget.borderRadius, (v) => Tween<double>(begin: v as double?));
    _borderSide = interpolate(_borderSide, widget.borderSide, (v) => _BorderSideTween(begin: v as BorderSide?));
    _backgroundBlur = interpolate(_backgroundBlur, widget.backgroundBlur, (v) => Tween<double>(begin: v as double?));
    _color = interpolate(_color, widget.color, (v) => ColorTween(begin: v as Color?));
    _gradient = interpolate(_gradient, widget.gradient, (v) => GradientTween(begin: v as Gradient?));
    _margin = interpolate(_margin, widget.margin, (v) => EdgeInsetsGeometryTween(begin: v as EdgeInsetsGeometry?));
    _padding = interpolate(_padding, widget.padding, (v) => EdgeInsetsGeometryTween(begin: v as EdgeInsetsGeometry?));
    _alignment = interpolate(_alignment, widget.alignment, (v) => AlignmentGeometryTween(begin: v as Alignment?));
    _shadows = interpolate(_shadows, widget.shadows, (v) => _BoxShadowListTween(begin: v as List<BoxShadow>?));
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    final double? effectiveWidth = _width?.evaluate(animation)?.clamp(0.0, .infinity);
    final double? effectiveHeight = _height?.evaluate(animation)?.clamp(0.0, .infinity);

    return TContainer(
      width: effectiveWidth,
      height: effectiveHeight,
      minWidth: widget.minWidth,
      maxWidth: widget.maxWidth,
      minHeight: widget.minHeight,
      maxHeight: widget.maxHeight,
      clipBehavior: widget.clipBehavior,
      borderShape: widget.borderShape,
      borderRadius: _borderRadius?.evaluate(animation) ?? 0.0,
      borderSide: _borderSide?.evaluate(animation) ?? BorderSide.none,
      margin: _margin?.evaluate(animation) ?? EdgeInsets.zero,
      padding: _padding?.evaluate(animation) ?? EdgeInsets.zero,
      alignment: (_alignment?.evaluate(animation) as Alignment?) ?? Alignment.topLeft,
      shadows: _shadows?.evaluate(animation) ?? [],
      color: _color?.evaluate(animation),
      gradient: _gradient?.evaluate(animation),
      decorationImage: widget.decorationImage,
      backgroundBlur: _backgroundBlur?.evaluate(animation) ?? 0.0,
      blendMode: widget.blendMode,
      child: widget.child,
    );
  }
}

class _BorderSideTween extends Tween<BorderSide?> {
  _BorderSideTween({super.begin});

  @override
  BorderSide? lerp(double t) {
    return (begin != null && end != null) ? BorderSide.lerp(begin!, end!, t) : null;
  }
}

class _BoxShadowListTween extends Tween<List<BoxShadow>?> {
  _BoxShadowListTween({super.begin});

  @override
  List<BoxShadow>? lerp(double t) {
    return BoxShadow.lerpList(begin, end, t);
  }
}
