// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:material_ui/material_ui.dart';
import 'package:torugo_widgets/torugo_widgets.dart';

enum TBorderShape { adaptive, roundedRect, superellipse }

/// Collection of methods that provides common Flutter shapes adapted to the target platform,
/// using superellipse shapes on Apple platforms and rounded rectangles elsewhere.
final class TAdaptiveShapes {
  /// Renders [RoundedSuperellipseBorder] on Apple platforms and [RoundedRectangleBorder] otherwise.
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [side]: Border side of the shape. Defaults to [BorderSide.none].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  static ShapeBorder shapeBorder({
    double radius = 0.0,
    BorderSide side = .none,
    TBorderShape shape = TBorderShape.adaptive,
  }) {
    radius = radius.clamp(0.0, double.infinity);
    if ((shape == .adaptive && TPlatform.isApple) || shape == .superellipse) {
      return RoundedSuperellipseBorder(side: side, borderRadius: BorderRadius.circular(radius));
    }
    return RoundedRectangleBorder(side: side, borderRadius: BorderRadius.circular(radius));
  }

  /// Renders [RoundedSuperellipseBorder] on Apple platforms or [RoundedRectangleBorder] as [OutlinedBorder].
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [side]: Border side of the shape. Defaults to [BorderSide.none].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  static OutlinedBorder outlinedBorder({
    double radius = 0.0,
    BorderSide side = .none,
    TBorderShape shape = TBorderShape.adaptive,
  }) {
    return shapeBorder(radius: radius, side: side, shape: shape) as OutlinedBorder;
  }

  /// Renders [ClipRSuperellipse] on Apple platforms and [ClipRRect] otherwise.
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [clipBehavior]: The clip behavior of the shape. Defaults to [Clip.antiAlias].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  /// - [child]: The child of the clip shape.
  static SingleChildRenderObjectWidget clipShape({
    double radius = 0.0,
    Clip clipBehavior = .antiAlias,
    TBorderShape shape = TBorderShape.adaptive,
    Widget? child,
  }) {
    radius = radius.clamp(0.0, double.infinity);
    if ((shape == .adaptive && TPlatform.isApple) || shape == .superellipse) {
      return ClipRSuperellipse(borderRadius: BorderRadius.circular(radius), clipBehavior: clipBehavior, child: child);
    }
    return ClipRRect(borderRadius: BorderRadius.circular(radius), clipBehavior: clipBehavior, child: child);
  }
}
